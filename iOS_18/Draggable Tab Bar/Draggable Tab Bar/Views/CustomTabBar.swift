//
//  CustomTabBar.swift
//  Draggable Tab Bar
//
//  Created by Matteo Buompastore on 09/07/24.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Environment(TabProperties.self) private var properties
    
    var body: some View {
        @Bindable var bindings = properties
        HStack(spacing: 0) {
            ForEach($bindings.tabs) { $tab in
                TabBarButton(tab: $tab)
            } //: Loop tabs
        } //: HSTACK
        .padding(.horizontal, 10)
        .background(.bar)
        .overlay(alignment: .topLeading) {
            if let id = properties.movingTab, let tab = properties.tabs.first(where: { $0.id == id }) {
                Image(systemName: tab.sybmolImage)
                    .font(.title2)
                    .offset(x: properties.initalTabLocation.minX,
                            y: properties.initalTabLocation.minY)
                    .offset(properties.moveOffset)
            }
        }
        .coordinateSpace(.named("VIEW"))
        .onChange(of: properties.moveLocation) { oldValue, newValue in
            if let droppingIndex = properties.tabs.firstIndex(where: {
                $0.rect.contains(newValue)
            }), let activeIndex = properties.tabs.firstIndex(where: { $0.id == properties.movingTab }), droppingIndex != activeIndex {
                /// Swapping with animation
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    (properties.tabs[droppingIndex], properties.tabs[activeIndex]) = (properties.tabs[activeIndex], properties.tabs[droppingIndex])
                }
                saveOrder()
            }
        }
        .sensoryFeedback(.success, trigger: properties.haptics)
    }
        
    private func saveOrder() {
        let order: [Int] = properties.tabs.reduce([]) { partialResult, model in
            return partialResult + [model.id]
        }
        UserDefaults.standard.setValue(order, forKey: "CustomTabOrder")
    }
    
}

struct TabBarButton: View {
    @Binding var tab: TabModel
    @Environment(TabProperties.self) private var properties
    
    /// UI
    @State private var tabRect: CGRect = .zero
    
    var body: some View {
        @Bindable var bindings = properties
        Image(systemName: tab.sybmolImage)
            .font(.title2)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .named("VIEW"))
            } action: { newValue in
                tabRect = newValue
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(properties.activeTab == tab.id ? .primary : properties.editMode ? .primary : .secondary)
            .opacity(properties.movingTab == tab.id ? 0 : 1)
            .overlay {
                if !properties.editMode {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .contentShape(.rect)
                        .onTapGesture {
                            properties.activeTab = tab.id
                        }
                } else {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .contentShape(.rect)
                        .gesture(CustomGesture(isEnabled: $bindings.editMode, trigger: { status in
                            if status {
                                properties.initalTabLocation = tabRect
                                properties.movingTab = tab.id
                            } else {
                                withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
                                    properties.initalTabLocation = tabRect
                                    properties.moveOffset = .zero
                                } completion: {
                                    properties.moveLocation = .zero
                                    properties.movingTab = nil
                                }
                            }
                        }, onChanged: { offset, location in
                            properties.moveOffset = offset
                            properties.moveLocation = location
                        }))
                }
            } //: Overlay Rect
            .loopingWiggle(properties.editMode)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                tab.rect = newValue
            }

    }
}

#Preview {
    CustomTabBar()
        .environment(TabProperties())
}

#Preview {
    ContentView()
}
