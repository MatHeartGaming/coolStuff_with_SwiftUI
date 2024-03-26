//
//  AnimatedSideBar.swift
//  Interactive SideMenu
//
//  Created by Matteo Buompastore on 26/03/24.
//

import SwiftUI

struct AnimatedSideBar<Content: View, MenuView: View, Background: View>: View {
    
    //MARK: - Properties
    
    /// Customisation
    var rotatesWhenExapnds: Bool = false
    var disablesInteraction: Bool = false
    var sideMenuWidth: CGFloat = 200
    var cornerRadius: CGFloat = 25
    @Binding var showMenu: Bool
    
    @ViewBuilder var content: (UIEdgeInsets) -> Content
    @ViewBuilder var menuView: (UIEdgeInsets) -> MenuView
    @ViewBuilder var background: Background
    
    /// UI
    @GestureState private var isDragging: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    
    /// To dim content when sidebar is being dragged
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader { _ in
                    menuView(safeArea)
                } //: GEOMETRY
                .frame(width: sideMenuWidth)
                /// Clipping
                .contentShape(.rect)
                
                GeometryReader { _ in
                    content(safeArea)
                } //: GEOMETRY
                .frame(width: size.width)
                .overlay {
                    if disablesInteraction && progress > 0 {
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    resetSideBar()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: progress * cornerRadius)
                }
                .scaleEffect(rotatesWhenExapnds ? 1 - (progress * 0.1) : 1, anchor: .trailing)
                .rotation3DEffect(
                    .degrees(rotatesWhenExapnds ? (progress * -15) : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0))
                
            } //: HSTACK
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            /// To avoid delay when dragging the ContentVIew when side bar is open
            .simultaneousGesture(dragGesture)
        } //: GEOMETRY
        .background(background)
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue {
                    showSideBar()
                } else {
                    resetSideBar()
                }
            }
        }
    }
    
    // MARK: - Gestures
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }
            .onChanged { value in
                /// To avoid interfering with NavigationStack pop gesture
                guard value.startLocation.x > 10 else { return }
                
                let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0) : 0
                offsetX = translationX
                calculateProgress()
            }
            .onEnded { value in
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + offsetX
                    if total > (sideMenuWidth * 0.5) {
                        showSideBar()
                    } else {
                        resetSideBar()
                    }
                }
            }
    }
    
    
    // MARK: - Functions
    
    private func showSideBar() {
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    private func resetSideBar() {
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    /// COnvdrt offset into serires of progress 0 - 1
    private func calculateProgress() {
        progress = max(min(offsetX / sideMenuWidth, 1), 0)
    }
    
}

#Preview {
    @State var showMenu = false
    return AnimatedSideBar(
        rotatesWhenExapnds: true,
        disablesInteraction: true,
        sideMenuWidth: 200,
        showMenu: $showMenu
    ) { safeArea in
        NavigationStack {
            List {
                NavigationLink("Detail View") {
                    Text("Hi Leon!")
                        .navigationTitle("Detail")
                }
            } //: LIST
            .navigationTitle("Home")
        } //: NAVIGATION
    } menuView: { safeArea in
        
    } background: {
        Rectangle()
            .fill(.sideMenu)
    }
}

#Preview {
    ContentView()
}
