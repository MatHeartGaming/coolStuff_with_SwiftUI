//
//  ContentView.swift
//  CustomDropDownMenu
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

/// DropDown Overlay
extension View {
    
    @ViewBuilder
    func dropDownOverlay(_ config: Binding<DropDownConfig>, values: [String]) -> some View {
        self
            .overlay {
                if config.wrappedValue.show {
                    DropDownView(values: values, config: config)
                        .transition(.identity)
                }
            }
    }
    
    
    /// Reverse Masking
    @ViewBuilder
    func reverseMask<Content: View>(_ alignment: Alignment, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
    
}

fileprivate struct DropDownView: View {
    
    // MARK: Properties
    var values: [String]
    @Binding var config: DropDownConfig
    
    /// UI
    @State private var activeItem: String?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ItemView(config.activeText)
                    .id(config.activeText)
                ForEach(filterValues, id: \.self) { item in
                    ItemView(item)
                } //: Loop
            } //: Lazy VGRID
            .scrollTargetLayout()
        } //: SCROLL
        /// To make items disappear when scrolling up
        .safeAreaPadding(.bottom, config.dropDownHeight - config.anchor.height)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .scrollIndicators(.hidden)
        .scrollPosition(id: $activeItem, anchor: .top)
        .frame(width: config.anchor.width, height: config.dropDownHeight)
        .background(.background)
        .mask(alignment: .top) {
            Rectangle()
                .frame(height: config.showContent ? config.dropDownHeight : config.anchor.height, alignment: .top)
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(config.showContent ? 180 : 0))
                .padding(.trailing, 15)
                .frame(height: config.anchor.height)
        }
        .clipShape(.rect(cornerRadius: config.cornerRadius))
        .offset(x: config.anchor.minX, y: config.anchor.minY)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            if config.showContent {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .reverseMask(.topLeading) {
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .frame(width: config.anchor.width, height: config.dropDownHeight)
                            .offset(x: config.anchor.minX, y: config.anchor.minY)
                        
                    }
                    .transition(.opacity)
                    .onTapGesture {
                        closeDropDown(activeItem ?? config.activeText)
                    }
            }
        }
        .ignoresSafeArea()
    }
    
    
    // MARK: Views
    @ViewBuilder
    func ItemView(_ item: String) -> some View {
        HStack {
            Text(item)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 15)
        .frame(height: config.anchor.height)
        .contentShape(.rect)
        .onTapGesture {
            closeDropDown(item)
        }
    }
    
    private func closeDropDown(_ item: String) {
        withAnimation(.easeInOut(duration: 0.35), completionCriteria: .logicallyComplete) {
            activeItem = item
            config.showContent = false
        } completion: {
            config.activeText = item
            config.show = false
        }
    }
    
    private var filterValues: [String] {
        values.filter({ $0 != config.activeText })
    }
    
}

/// Source View
struct SourceDropDownView: View {
    
    @Binding var config: DropDownConfig
    
    var body: some View {
        HStack {
            Text(config.activeText)
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.down")
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: config.cornerRadius))
        .contentShape(.rect(cornerRadius: config.cornerRadius))
        .onTapGesture {
            config.show = true
            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                config.showContent = true
            }
        }
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { newValue in
            config.anchor = newValue
        }

    }
    
}

/// Config
struct DropDownConfig {
    var activeText: String
    var show: Bool = false
    var showContent: Bool = false
    var dropDownHeight: CGFloat = 200
    /// Source View Position
    var anchor: CGRect = .zero
    var cornerRadius: CGFloat = 10
}

#Preview {
    ContentView()
}
