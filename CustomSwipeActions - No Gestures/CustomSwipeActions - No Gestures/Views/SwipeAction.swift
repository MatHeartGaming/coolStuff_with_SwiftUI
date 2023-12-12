//
//  SwipeAction.swift
//  CustomSwipeActions - No Gestures
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI

/// Custom Swipe Actions
struct SwipeAction<Content: View>: View {
    
    //MARK: - PROPERTIES
    var cornerRadius: CGFloat = .zero
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    
    /// View Properties
    @Environment(\.colorScheme) private var scheme
    let viewID = UUID()
    @State private var isEnabled = true
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        
        /// Used to reset the scroll view to its original position when a swipe action is tapped
        ScrollViewReader { scrollProxy in
            
            ScrollView(.horizontal) {
                
                LazyHStack(spacing: 0) {
                    content
                        .rotationEffect(.degrees(direction == .leading ? -180 : 0))
                        /// To take the full available space
                        .containerRelativeFrame(.horizontal)
                        .background(scheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    
                    ActionButtons() {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
                
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned) // <-- Requires scrollTargetLayout() insiede the ScrollView
            .background {
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.degrees(direction == .leading ? 180 : 0))
            
        } //: ScrollView Reader
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    
    /// Action Buttons
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> Void) -> some View {
        /// Each button will have a 100 of Width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    
                    ForEach(filteredActions) { button in
                        Button {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                        } label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        } //: Button
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.degrees(direction == .leading ? -180 : 0))

                    } //: LOOP
                    
                } //: HSTACK
            } //: RECTANGLE
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return (minX > 0 ? -minX : 0)
    }
    
    var filteredActions: [Action] {
        return actions.filter({ $0.isEnabled })
    }
    
}


/// Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


/// Custom Transition
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset(y: phase == .identity ? .zero : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}


/// Swipe Direction
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
            
        case .leading:
            return .leading
            
        case .trailing:
            return .leading
            
        }
    }
}

struct Action: Identifiable {
    
    private(set) var id = UUID()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> Void
    
}

@resultBuilder
struct ActionBuilder {
    
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
    
}
