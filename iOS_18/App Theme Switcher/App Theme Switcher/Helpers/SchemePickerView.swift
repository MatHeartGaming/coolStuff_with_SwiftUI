//
//  SchemePickerView.swift
//  App Theme Switcher
//
//  Created by Matteo Buompastore on 28/08/24.
//

import SwiftUI

enum AppScheme: String {
    case dark = "Dark"
    case light = "Light"
    case device = "Device"
}

fileprivate struct SchemePreview: Identifiable {
    let id: UUID = .init()
    var image: UIImage?
    var text: String
}

struct SchemeHostView<Content: View>: View {
    
    // MARK: Properties
    @ViewBuilder var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            window.overrideUserInterfaceStyle = appScheme == .dark ? .dark : appScheme == .light ? .light : .unspecified
        }
    }
    
    /// UI
    @AppStorage("AppScheme") private var appScheme: AppScheme = .device
    @SceneStorage("ShowScenePickerView") private var showPickerView: Bool = false
    @Environment(\.colorScheme) private var scheme
    @State private var schemePreviews: [SchemePreview] = []
    @State private var showSheet: Bool = false
    @State private var overlayWindow: UIWindow?
    
    var body: some View {
        content
            .sheet(isPresented: $showPickerView, onDismiss: {
                schemePreviews = []
                showPickerView = false
            }) {
                SchemePickerView(previews: $schemePreviews)
            }
            .onChange(of: showPickerView) { oldValue, newValue in
                if newValue {
                    generateSchemePreviews()
                } else {
                    showSheet = false
                }
            }
            .onAppear {
                if let scene = (UIApplication.shared.connectedScenes.first as? UIWindowScene), overlayWindow == nil {
                    let window = UIWindow(windowScene: scene)
                    window.backgroundColor = .clear
                    window.isHidden = false
                    window.isUserInteractionEnabled = false
                    let emptyController = UIViewController()
                    emptyController.view.backgroundColor = .clear
                    window.rootViewController = emptyController
                    
                    overlayWindow = window
                }
            }
    }
    
    private func showOverlayImageView(_ image: UIImage?) {
        if overlayWindow?.rootViewController?.view.subviews.isEmpty ?? false {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            overlayWindow?.rootViewController?.view.addSubview(imageView)
        }
    }
    
    private func removeOverlayImageView() {
        overlayWindow?.rootViewController?.view.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    /// Generating Scheme Previews
    private func generateSchemePreviews() {
        Task {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow, schemePreviews.isEmpty {
                let size = window.screen.bounds.size
                
                let defaultStyle = window.overrideUserInterfaceStyle
                
                let defaultSchemePreview = window.image(size)
                schemePreviews.append(
                    .init(image: defaultSchemePreview, 
                          text: scheme == .dark ? AppScheme.dark.rawValue : AppScheme.light.rawValue)
                )
                
                showOverlayImageView(defaultSchemePreview)
                
                window.overrideUserInterfaceStyle = scheme.oppositeInterfaceStyle
                let otherSchemePreview = window.image(size)
                schemePreviews.append(
                    .init(image: otherSchemePreview, 
                          text: scheme == .dark ? AppScheme.light.rawValue: AppScheme.dark.rawValue)
                )
                
                if scheme == .dark {
                    schemePreviews = schemePreviews.reversed()
                }
                
                /// Resetting to its default Style
                window.overrideUserInterfaceStyle = defaultStyle
                try? await Task.sleep(for: .seconds(0))
                
                removeOverlayImageView()
                
                showSheet = true
                
            }
        }
    }
    
}

fileprivate extension ColorScheme {
    var oppositeInterfaceStyle: UIUserInterfaceStyle {
        return self == .dark ? .light : .dark
    }
}

struct SchemePickerView: View {
    
    @Binding fileprivate var previews: [SchemePreview]
    @AppStorage("AppScheme") private var appScheme: AppScheme = .device
    @State private var localSchemeState: AppScheme = .device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appearance")
                .font(.title3.bold())
            
            Spacer(minLength: 0)
            
            GeometryReader { _ in
                HStack(spacing: 0) {
                    ForEach(previews) { preview in
                        SchemeCardView([preview])
                    } //: Loop Previews
                    SchemeCardView(previews)
                } //: HSTACK
            } //: GEOMETRY
            
        } //: VSTACK
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            ZStack {
                Rectangle()
                    .fill(.background)
                Rectangle()
                    .fill(Color.primary.opacity(0.05))
            } //: ZSTACK
            .clipShape(.rect(cornerRadius: 20))
        }
        .padding(.horizontal, 15)
        .presentationDetents([.height(320)])
        .presentationBackground(.clear)
        .onChange(of: appScheme) { oldValue, newValue in
            localSchemeState = newValue
        }
        .animation(.easeInOut(duration: 0.25), value: appScheme)
    }
    
    
    @ViewBuilder
    fileprivate func SchemeCardView(_ preview: [SchemePreview]) -> some View {
        VStack(spacing: 6) {
            if let image = preview.first?.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        if let secondImage = preview.last?.image, preview.count == 2 {
                            GeometryReader {
                                let width = $0.size.width / 2
                                Image(uiImage: secondImage)
                                    .resizable()
                                    .scaledToFit()
                                    .mask(alignment: .trailing) {
                                        Rectangle()
                                            .frame(width: width)
                                    }
                            }
                        }
                    }
                    .clipShape(.rect(cornerRadius: 15))
            }
            
            let text = preview.count == 2 ? "Device" : preview.first?.text ?? ""
            
            Text(text)
                .font(.caption)
                .foregroundStyle(.gray)
            
            ZStack {
                Image(systemName: "circle")
                if appScheme.rawValue == text {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.primary)
                        .transition(.blurReplace)
                }
            } //: ZSTACK
            
        } //: VSTACK
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            if preview.count == 2 {
                appScheme = .device
            } else {
                appScheme = preview.first?.text == AppScheme.dark.rawValue ? .dark : .light
            }
            updateScheme()
        }
    }
    
    private func updateScheme() {
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            window.overrideUserInterfaceStyle = appScheme == .dark ? .dark : appScheme == .light ? .light : .unspecified
        }
    }
    
}

extension UIView {
    
    func image(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            drawHierarchy(in: .init(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
    
}


#Preview {
    SchemePickerView(previews: .constant(.init()))
}

#Preview {
    SchemeHostView {
        ContentView()
    }
}
