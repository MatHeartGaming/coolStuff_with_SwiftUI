//
//  CustomPicker.swift
//  Custom3DPicker
//
//  Created by Matteo Buompastore on 10/07/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func customPicker(_ config: Binding<PickerConfig>, items: [String]) -> some View {
        self
            .overlay {
                if config.wrappedValue.show {
                    CustomPickerView(texts: items, config: config)
                        .transition(.identity)
                }
            }
    }
}

struct SourcePickerView: View {
    
    @Binding var config: PickerConfig
    
    var body: some View {
        Text(config.text)
            .foregroundStyle(.blue)
            .frame(height: 20)
            .opacity(config.show ? 0 : 1)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                config.sourceFrame = newValue
            }
    }
}

struct PickerConfig {
    var text: String
    init(text: String) {
        self.text = text
    }
    
    var show: Bool = false
    /// Used for custom matched geometry effect
    var sourceFrame: CGRect = .zero
}

/// CustomPickerView
fileprivate struct CustomPickerView: View {
    
    var texts: [String]
    @Binding var config: PickerConfig
    
    /// UI
    @State private var activeText: String?
    @State private var showContents: Bool = false
    @State private var showScrollView: Bool = false
    @State private var expandItems: Bool = false
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(showContents ? 1 : 0)
                .ignoresSafeArea()
            
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(texts, id: \.self) { text in
                        CardView(text, size: size)
                    } //: Loop texts
                } //: VSTACK
                .scrollTargetLayout()
            } //: V-SCROLL
            /// Making it to start and stop at the center
            .safeAreaPadding(.top, (size.height * 0.5) - 20)
            .safeAreaPadding(.bottom, (size.height * 0.5))
            .scrollPosition(id: $activeText, anchor: .center)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
            .opacity(showScrollView ? 1 : 0)
            allowsHitTesting(expandItems && showScrollView)
            
            let offset: CGSize = .init(
                width: showContents ? size.width * -0.3 : config.sourceFrame.minX,
                height: showContents ? -10 : config.sourceFrame.minY)
            
            Text(config.text)
                .fontWeight(showContents ? .semibold : .regular)
                .frame(height: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, 
                       alignment: showContents ? .trailing : .topLeading)
                .offset(offset)
                .opacity(showScrollView ? 0 : 1)
                .ignoresSafeArea(.all, edges: showContents ? [] : .all)
            
            CloseButton()
            
            
        } //: GEOMETRY
        .task {
            /// Only the first time
            guard activeText == nil else { return }
            activeText = config.text
            withAnimation(.easeInOut(duration: 0.3)) {
                showContents = true
            }
            try? await Task.sleep(for: .seconds(0.3))
            showScrollView = true
            
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                expandItems = true
            }
        }
        .onChange(of: activeText) { oldValue, newValue in
            if let newValue {
                config.text = newValue
            }
        }
    }
    
    
    // MARK: Views
    
    func CloseButton() -> some View {
        Button {
            Task {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expandItems = false
                }
                try? await Task.sleep(for: .seconds(0.2))
                showScrollView = false
                withAnimation(.easeInOut(duration: 0.2)) {
                    showContents = false
                }
                try? await Task.sleep(for: .seconds(0.2))
                config.show = false
            }
        } label: {
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundStyle(Color.primary)
                .frame(width: 45, height: 45)
                .contentShape(.rect)
        }
        /// Making it right next to the active picker element
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .offset(x: expandItems ? -50 : 50, y: -10)
    }
    
    @ViewBuilder
    private func CardView(_ text: String, size: CGSize) -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            Text(text)
                .fontWeight(.semibold)
                .foregroundStyle(config.text == text ? .blue : .gray)
                .offset(y: offset(proxy))
                .opacity(expandItems ? 1 : config.text == text ? 1 : 0)
                /// To avoid view overlapping
                .clipped()
                .offset(x: -width * 0.3)
                /// Changing trailing to leading and switching signes it can be used on the left side
                .rotationEffect(.degrees(expandItems ? -rotation(proxy, size) : .zero), anchor: .topTrailing)
                .opacity(opacity(proxy, size))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        } //: GEOMETRY
        .frame(height: 20)
        .lineLimit(1)
    }
    
    
    
    // MARK: Functions
    
    private func rotation(_ proxy: GeometryProxy, _ size: CGSize) -> CGFloat {
        let height = size.height * 0.5
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        /// You can use your own rotation
        let maxRotation: CGFloat = 220
        let progress = minY / height
        return progress * maxRotation
    }
    
    private func opacity(_ proxy: GeometryProxy, _ size: CGSize) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = size.height * 0.5
        let progress = (minY / height) * 2.8
        /// Eliminating negative opacity
        let opacity = progress < 0 ? 1 + progress : 1 - progress
        return opacity
    }
    
    private func offset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        return expandItems ? 0 : -minY
    }
    
}

struct CustomPicker: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    /*@Previewable
    @State var config = PickerConfig(text: "SwiftUI")
    let texts = ["SwiftUI", "UIKit", "macOS", "iOS", "XCode", "WWDC"]
    CustomPickerView(texts: texts, config: $config)*/
    ContentView()
}
