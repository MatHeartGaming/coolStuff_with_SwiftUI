//
//  CustomCarousel.swift
//  AutoScroll Infinite Carousel
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI

struct CustomCarousel<Content: View>: View {
    
    // MARK: Properties
    @Binding var activeIndex: Int
    @ViewBuilder var content: Content
    @State private var scrollPosition: Int?
    @State private var offsetBasedPosition: Int = 0
    @State private var isSettled: Bool = false
    @State private var isScrolling: Bool = false
    @GestureState private var isHoldingScreen: Bool = false
    @State private var timer = Timer.publish(every: autoScrollDuration, on: .main, in: .default).autoconnect()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Group(subviews: content) { collection in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        if let lastItem = collection.last {
                            lastItem
                                .frame(width: size.width, height: size.height)
                                .id(-1)
                        }
                        ForEach(collection.indices, id: \.self) { index in
                            collection[index]
                                .frame(width: size.width, height: size.height)
                                .id(index)
                        }
                        if let firstItem = collection.first {
                            firstItem
                                .frame(width: size.width, height: size.height)
                                .id(collection.count)
                        }
                    } //: HSTACK
                    .scrollTargetLayout()
                } //: H-SCROLL
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .onScrollPhaseChange { oldPhase, newPhase in
                    isScrolling = newPhase.isScrolling
                    if !isScrolling && scrollPosition == -1 {
                        scrollPosition = collection.count - 1
                    }
                    if !isScrolling && scrollPosition == collection.count && !isHoldingScreen {
                        scrollPosition = 0
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0).updating($isHoldingScreen, body: { _, out, _ in
                        out = true
                    })
                )
                .onChange(of: isHoldingScreen, { oldValue, newValue in
                    if newValue {
                        timer.upstream.connect().cancel()
                    } else {
                        if isSettled && scrollPosition != offsetBasedPosition {
                            scrollPosition = offsetBasedPosition
                        }
                        timer = Timer.publish(every: Self.autoScrollDuration, on: .main, in: .default).autoconnect()
                    }
                })
                .onReceive(timer) { _ in
                    /// Safety check
                    guard !isHoldingScreen && !isScrolling else { return }
                    
                    let nextIndex = (scrollPosition ?? 0) + 1
                    
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        scrollPosition = (nextIndex == collection.count + 1) ? 0 : nextIndex
                    }
                }
                .onChange(of: scrollPosition) { oldValue, newValue in
                    if let newValue {
                        if newValue == 1 {
                            activeIndex = collection.count - 1
                        } else if newValue == collection.count {
                            activeIndex = 0
                        } else {
                            activeIndex = max(min(newValue, collection.count - 1), 0)
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { $0.contentOffset.x } action: { oldValue, newValue in
                    isSettled = size.width > 0 ? (Int(newValue) % Int(size.width) == 0) : false
                    let index = size.width > 0 ? Int((newValue / size.width).rounded() - 1) : 0
                    offsetBasedPosition = index
                    
                    if isSettled && (scrollPosition != index || index == collection.count) && !isScrolling && !isHoldingScreen {
                        scrollPosition = index == collection.count ? 0 : index
                    }
                }

            } //: GROUP
            .onAppear {
                scrollPosition = 0
            }
            
        } //: GEOMETRY
    }
    
    
    static var autoScrollDuration: CGFloat {
        return 1.8
    }
    
}

#Preview {
    ContentView()
}
