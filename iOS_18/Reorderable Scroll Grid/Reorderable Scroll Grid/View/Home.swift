//
//  Home.swift
//  Reorderable Scroll Grid
//
//  Created by Matteo Buompastore on 19/09/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    var safeArea: EdgeInsets
    @State private var controls: [Control] = controlList
    @State private var selectedControl: Control?
    @State private var selectedControlFrame: CGRect = .zero
    @State private var selectedControlScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    
    /// ScrollView Properties
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var lastActiveScrollOffset: CGFloat = 0
    @State private var maximumScrollSize: CGFloat = 0
    @State private var scrollTimer: Timer?
    @State private var topRegion: CGRect = .zero
    @State private var bottomRegion: CGRect = .zero
    @State private var isList: Bool = false
    
    /// Optional Features
    @State private var hapticsTrigger: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(
                columns: Array(repeating: GridItem(),
                count: isList ? 1 : 2),
                spacing: 20) {
                ForEach($controls) { $control in
                    ControlView(control: control)
                        .opacity(selectedControl?.id == control.id ? 0 : 1)
                    /// Filling up the frame property with the help of new onGeometryChange
                        .onGeometryChange(for: CGRect.self) { proxy in
                            proxy.frame(in: .global)
                        } action: { newValue in
                            if selectedControl?.id == control.id {
                                selectedControlFrame = newValue
                            }
                            control.frame = newValue
                        }
                        .gesture(customCombinedGesture(control))

                } //: Loop Controls
            } //: Lazy VSTACK
            .padding(25)
        } //: V-SCROLL
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentOffset.y + $0.contentInsets.top
        }, action: { _, newValue in
            currentScrollOffset = newValue
        })
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentSize.height + $0.containerSize.height
        }, action: { _, newValue in
            maximumScrollSize = newValue
        })
        .overlay(alignment: .topLeading) {
            if let selectedControl {
                ControlView(control: selectedControl)
                    .frame(width: selectedControl.frame.width, height: selectedControl.frame.height)
                    .scaleEffect(selectedControlScale)
                    .offset(x: selectedControl.frame.minX, y: selectedControl.frame.minY)
                    .offset(offset)
                    .ignoresSafeArea()
                    .transition(.identity)
            }
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.clear)
                .frame(height: 20 + safeArea.top)
                .onGeometryChange(for: CGRect.self) {
                    $0.frame(in: .global)
                } action: { newValue in
                    topRegion = newValue
                }
                .offset(y: -safeArea.top)
                .allowsHitTesting(false)

        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.clear)
                .frame(height: 20 + safeArea.bottom)
                .onGeometryChange(for: CGRect.self) {
                    $0.frame(in: .global)
                } action: { newValue in
                    bottomRegion = newValue
                }
                .offset(y: safeArea.bottom)
                .allowsHitTesting(false)

        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                withAnimation {
                    isList.toggle()
                }
            }, label: {
                Image(systemName: isList ? "rectangle.grid.1x2" : "square.grid.2x2")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    
            })
            .offset(x: -15,y: -15)
        }
        /// To avoid multiple Gestures Interactions
        .allowsHitTesting(selectedControl == nil)
        .sensoryFeedback(.impact, trigger: hapticsTrigger)
    }
    
    
    // MARK: Functions
    
    private func customCombinedGesture(_ control: Control) -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))
            .onChanged { value in
                switch value {
                    case .second(let status, let value):
                    if status {
                        if selectedControl == nil {
                            selectedControl = control
                            selectedControlFrame = control.frame
                            lastActiveScrollOffset = currentScrollOffset
                            hapticsTrigger.toggle()
                            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                                selectedControlScale = 1.05
                            }
                        }
                        
                        if let value {
                            offset = value.translation
                            let location = value.location
                            checkAndScroll(location)
                        }
                    }
                    
                default: ()
                }
            }
            .onEnded { _ in
                scrollTimer?.invalidate()
                
                withAnimation(.snappy(duration: 0.25, extraBounce: 0), completionCriteria: .logicallyComplete) {
                    
                    /// Updating Control Frame with latest update
                    selectedControl?.frame = selectedControlFrame
                    
                    selectedControlScale = 1
                    offset = .zero
                } completion: {
                    selectedControl = nil
                    scrollTimer = nil
                    lastActiveScrollOffset = 0
                }
            }
    }
    
    private func checkAndScroll(_ location: CGPoint) {
        let topStatus = topRegion.contains(location)
        let bottomStatus = bottomRegion.contains(location)
        
        if topStatus || bottomStatus {
            /// Initializing only once
            guard scrollTimer == nil else { return }
            scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                
                /// The 10 represents the scroll speed
                if topStatus {
                    lastActiveScrollOffset = max(lastActiveScrollOffset - 10, 0)
                } else {
                    lastActiveScrollOffset = min(lastActiveScrollOffset + 10, maximumScrollSize)
                }
                
                scrollPosition.scrollTo(y: lastActiveScrollOffset)
                
                /// Swapping item
                checkAndSwapItems(location)
            })
        } else {
            /// Removing Timer
            scrollTimer?.invalidate()
            scrollTimer = nil
            
            checkAndSwapItems(location)
        }
    }
    
    private func checkAndSwapItems(_ location: CGPoint) {
        if let currentIndex = controls.firstIndex(where: { $0.id == selectedControl?.id }),
           let fallingIndex = controls.firstIndex(where: { $0.frame.contains(location) }) {
            
            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                (controls[currentIndex], controls[fallingIndex]) = (controls[fallingIndex], controls[currentIndex])
            }
            
        }
    }
    
}

struct ControlView: View {
    
    var control: Control
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: control.symbol)
                .font(.title3)
            
            Text(control.title)
            
            Spacer(minLength: 0)
        } //: HSTACK
        .padding(.horizontal, 15)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        }
    }
    
}

#Preview {
    GeometryReader {
        Home(safeArea: $0.safeAreaInsets)
    }
}

#Preview("ContentView") {
    ContentView()
}
