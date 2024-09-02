//
//  CustomHeaderView.swift
//  Playstation App Bar
//
//  Created by Matteo Buompastore on 28/08/24.
//

import SwiftUI

struct CustomHeaderView: View {
    
    // MARK: Properties
    var size: CGSize
    
    /// UI
    @State private var activeTab: HeaderTab = .chat
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @State private var dragProgress: CGFloat = 0
    @Namespace private var animation
    
    var body: some View {
        let height: CGFloat = size.height + safeArea.top
        VStack(spacing: 0) {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        SwiftUI.Tab.init(value: .chat) {
                            Text("Chat")
                        }
                        SwiftUI.Tab.init(value: .friends) {
                            Text("Friends")
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                } else {
                    TabView(selection: $activeTab) {
                        Text("Chats")
                            .tag(HeaderTab.chat)
                        Text("Friends")
                            .tag(HeaderTab.friends)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            } //: Group TabView
            .animation(dragProgress == 1 ? .snappy(duration: 0.25, extraBounce: 0) : .none, value: activeTab)
            .background {
                Rectangle()
                    .fill(.black.gradient)
                    .rotationEffect(.degrees(180))
                    .mask {
                        let isShapeInTrailingSide: Bool = activeTab == .friends
                        VStack(alignment: isShapeInTrailingSide ? .trailing : .leading, spacing: 0) {
                            UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15)
                            
                            if isShapeInTrailingSide {
                                ActiveHeaderIndicatorShape()
                                    .matchedGeometryEffect(id: "ACTIVEHEADERTAB", in: animation)
                                    .frame(width: size.width / 2, height: 50)
                                    .scaleEffect(-1)
                            } else {
                                ActiveHeaderIndicatorShape()
                                    .matchedGeometryEffect(id: "ACTIVEHEADERTAB", in: animation)
                                    .frame(width: size.width / 2, height: 50)
                            }
                            
                            
                        } //: VSTACK
                        .compositingGroup()
                    }
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 2, y: 5)
                    .padding(.bottom, -50)
                    .animation(.snappy(duration: 0.25, extraBounce: 0), value: activeTab)
            } //: Background
            .offset(y: -150 + (150 * dragProgress))
            
            Rectangle()
                .fill(.clear)
                .frame(height: 50)
        } //: VSTACK
        .frame(height: height)
        .offset(y: -(height - 50))
        .offset(y: offset)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15)
                .fill(.black.gradient)
                .rotationEffect(.degrees(180))
                .clipShape(DragIndicatorCutoutShape(progress: dragProgress))
                .overlay(alignment: .bottom) {
                    ArrowIndicator()
                }
                .background {
                    let extraOffset = (dragProgress > 0.8 ? (dragProgress - 0.8) / 0.2 : 0) * 100
                    Rectangle()
                        .fill(Color("BG"))
                        .offset(y: extraOffset)
                }
                .offset(y: -(height - 50))
                .offset(y: offset)
            
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                HeaderTabButton(.chat, alignment: .leading)
                
                Spacer(minLength: 0)
                    .frame(maxWidth: .infinity)
                
                HeaderTabButton(.friends, alignment: .trailing)
            } //: HSTACK
            .padding(.horizontal, 25)
            .frame(height: 50)
            .contentShape(.rect)
            .offset(y: -(height - 50))
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.height + lastStoredOffset
                        /// To limit header expansion beyond its limit
                        offset = max(min(translation, height - safeArea.top - 50), 0)
                        dragProgress = offset / (height - safeArea.top - 50)
                    }.onEnded { value in
                        let velocity = value.velocity.height / 5
                        withAnimation(.snappy(duration: 0.2, extraBounce: 0)) {
                            if (offset + velocity) > (height * 0.4) {
                                offset = height - safeArea.top - 50
                                dragProgress = 1
                            } else {
                                offset = 0
                                dragProgress = 0
                            }
                        }
                        
                        lastStoredOffset = offset
                    }
            )
        } //: Overlay Header Buttons
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func HeaderTabButton(_ tab: HeaderTab, alignment: Alignment) -> some View {
        GeometryReader {
            let width = $0.size.width
            let mid = (width / 2) - 30
            Image(systemName: tab.rawValue)
                .font(.title3)
                .foregroundStyle(.white)
                .offset(x: mid * (alignment == .leading ? dragProgress : -dragProgress))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                    
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        offset = size.height - 50
                        dragProgress = 1
                    }
                    
                    lastStoredOffset = offset
                }
        }
    }
    
    /// Dynamic Arrow Indicator
    @ViewBuilder
    private func ArrowIndicator() -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(.white)
                .frame(width: 30, height: 4)
                .offset(x: dragProgress * 3)
                .rotationEffect(.degrees(dragProgress * -30), anchor: .center)
            Rectangle()
                .fill(.white)
                .frame(width: 30, height: 4)
                .offset(x: dragProgress * -3)
                .rotationEffect(.degrees(dragProgress * 30), anchor: .center)
        } //: HSTACK
        .compositingGroup()
        .offset(y: dragProgress * -40)
        .scaleEffect(1 - (dragProgress * 0.5))
    }
}

#Preview {
    ContentView()
}
