//
//  Hero.swift
//  Universal Hero Effect
//
//  Created by Matteo Buompastore on 02/02/24.
//

import SwiftUI

struct HeroWrapper<Content: View>: View {
    
    //MARK: - Properties
    @ViewBuilder var content: Content
    
    /// UI
    @Environment(\.scenePhase) private var scene
    @State private var overlayWindow: PassThroughWindow?
    @StateObject private var heroModel: HeroModel = HeroModel()
    
    var body: some View {
        content
            .customOnChange(value: scene) { newValue in
                if newValue == .active {
                    addOverlayWindow()
                }
            }
            .environmentObject(heroModel)
    }
    
    
    //MARK: - Functions
    
    private func addOverlayWindow() {
        /// Manually looking for the active scene to support iPadOS with multiple window sessions
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               scene.activationState == .foregroundActive, overlayWindow == nil {
                
                let window = PassThroughWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.isUserInteractionEnabled = false
                window.isHidden = false
                
                let rootController = UIHostingController(
                    rootView: HeroLayerView().environmentObject(heroModel)
                )
                rootController.view.frame = windowScene.screen.bounds
                rootController.view.backgroundColor = .clear
                
                window.rootViewController = rootController
                
                self.overlayWindow = window
                
            }
        }
        
        if self.overlayWindow == nil {
            print("No window scene found!")
        }
    }
    
}

//MARK: - Source View
struct SourceView<Content: View>: View {
    
    //MARK: - Properties
    let id: String
    @ViewBuilder var content: Content
    @EnvironmentObject private var heroModel: HeroModel
    
    var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                if let index, heroModel.info[index].isActive {
                    return [id: anchor]
                }
                return [:]
            })
            .onPreferenceChange(AnchorKey.self, perform: { value in
                if let index, heroModel.info[index].isActive,
                   heroModel.info[index].sourceAnchor == nil {
                    heroModel.info[index].sourceAnchor = value[id]
                }
            })
    }
    
    private var index: Int? {
        if let index = heroModel.info.firstIndex(where: { $0.infoID == id }) {
            return index
        }
        return nil
    }
    
    var opacity: CGFloat {
        if let index {
            return heroModel.info[index].isActive ? 0 : 1
        }
        return 1
    }
    
}

//MARK: - Destination View
struct DestinationView<Content: View>: View {
    
    //MARK: - Properties
    let id: String
    @ViewBuilder var content: Content
    @EnvironmentObject private var heroModel: HeroModel
    
    var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                if let index, heroModel.info[index].isActive {
                    return ["\(id)DESTINATION": anchor]
                }
                return [:]
            })
            .onPreferenceChange(AnchorKey.self, perform: { value in
                if let index, heroModel.info[index].isActive {
                    heroModel.info[index].destinationAnchor = value["\(id)DESTINATION"]
                }
            })
    }
    
    private var index: Int? {
        if let index = heroModel.info.firstIndex(where: { $0.infoID == id }) {
            return index
        }
        return nil
    }
    
    var opacity: CGFloat {
        if let index {
            return heroModel.info[index].isActive ? (heroModel.info[index].hideView ? 1 : 0) : 1
        }
        return 1
    }
}

//MARK: - Environment Object
fileprivate class HeroModel: ObservableObject {
    
    @Published var info = [HeroInfo]()
    
}

/// Individual Hero Animation View Info
fileprivate struct HeroInfo: Identifiable {
    
    private(set) var id: UUID = . init()
    private(set) var infoID: String
    var isActive: Bool = false
    var layerView: AnyView?
    var animateView: Bool = false
    var hideView: Bool = false
    var sourceAnchor: Anchor<CGRect>?
    var destinationAnchor: Anchor<CGRect>?
    var sCornerRadius: CGFloat = 0
    var dCornerRadius: CGFloat = 0
    var completion: (Bool) -> Void = { _ in }

    init(id: String) {
        self.infoID = id
    }
    
}

fileprivate struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    /// Used to retrieve size and position infos about the SwiftUI View, and with that we can implement the Hero Effect
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { anchor1, anchor2 in
            anchor2
        }
    }
}


//MARK: - Extensions
extension View {
    
    @ViewBuilder
    func customOnChange<Value: Equatable>(value: Value, initial: Bool = false, completion: @escaping (Value) -> Void) -> some View {
        if #available(iOS 17, *) {
            self
                .onChange(of: value, initial: initial) { oldValue, newValue in
                    completion(newValue)
                }
        } else {
            self
                .onChange(of: value) { newValue in
                    completion(newValue)
                }
                .onAppear {
                    if initial {
                        completion(value)
                    }
                }
        }
    }
    
}

extension View {
    
    @ViewBuilder
    func heroLayer<Content: View>(id: String,
                                  animate: Binding<Bool>,
                                  sourceCornerRadius: CGFloat = 0,
                                  destinationCornerRadius: CGFloat = 0,
                                  @ViewBuilder content: @escaping () -> Content,
                                  completion: @escaping (Bool) -> Void) -> some View {
        self
            .modifier(HeroLayerViewModifier(
                id: id,
                animate: animate,
                layer: content,
                completion: completion)
            )
        
    }
    
}

fileprivate struct HeroLayerViewModifier<Layer: View>: ViewModifier {
    
    let id: String
    @Binding var animate: Bool
    var sourceCornerRadius: CGFloat = 0
    var destinationCornerRadius: CGFloat = 0
    @ViewBuilder var layer: Layer
    
    /// Hero Model
    @EnvironmentObject private var heroModel: HeroModel
    
    var completion: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !heroModel.info.contains(where: { $0.infoID == id }) {
                    heroModel.info.append(HeroInfo(id: id))
                }
            }
            .customOnChange(value: animate) { newValue in
                if let index = heroModel.info.firstIndex(where: { $0.infoID == id }) {
                    /// Setting up all the necessary properties for the anmation
                    heroModel.info[index].isActive = true
                    heroModel.info[index].layerView = AnyView(layer)
                    heroModel.info[index].sCornerRadius = sourceCornerRadius
                    heroModel.info[index].dCornerRadius = destinationCornerRadius
                    heroModel.info[index].completion = completion
                    
                    if newValue {
                        /// Little delay in order for the view to load and read its Anchor values
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                heroModel.info[index].animateView = true
                            }
                        }
                    } else {
                        heroModel.info[index].hideView = false
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            heroModel.info[index].animateView = false
                        }
                    }
                }
            }
    }
    
}

fileprivate struct HeroLayerView: View {
    
    @EnvironmentObject private var heroModel: HeroModel
    
    var body: some View {
        GeometryReader { proxy in
            ForEach($heroModel.info) { $info in
                /// Retrieving bounds from anchor values
                ZStack {
                    if let sourceAnchor = info.sourceAnchor,
                       let destinationAnchor = info.destinationAnchor,
                       let layerView = info.layerView,
                       !info.hideView {
                        let sRect = proxy[sourceAnchor]
                        let dRect = proxy[destinationAnchor]
                        let animateView = info.animateView
                        
                        let size = CGSize(width: animateView ? dRect.size.width : sRect.size.width,
                                          height: animateView ? dRect.size.height : sRect.size.height)
                        
                        let offset = CGSize(width: animateView ? dRect.minX : sRect.minX,
                                          height: animateView ? dRect.minY : sRect.minY)
                        
                        layerView
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: animateView ? info.dCornerRadius : info.sCornerRadius))
                            .offset(offset)
                            .transition(.identity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                } //: ZSTACK
                .customOnChange(value: info.animateView) { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                        if !newValue {
                            /// Resetting data once the view goes to back to its source state
                            info.isActive = false
                            info.layerView = nil
                            info.sourceAnchor = nil
                            info.destinationAnchor = nil
                            info.sCornerRadius = 0
                            info.dCornerRadius = 0
                            
                            info.completion(false)
                        } else {
                            info.hideView = true
                            info.completion(true)
                        }
                    }
                }
            }
        } //: GEOMETRY
    }
}

fileprivate class PassThroughWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
    
}

#Preview {
    HeroWrapper(content: {
        ContentView()
            .environmentObject(HeroModel())
    })
}
