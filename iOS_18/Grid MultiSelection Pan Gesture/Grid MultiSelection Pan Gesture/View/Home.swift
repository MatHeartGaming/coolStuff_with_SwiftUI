//
//  Home.swift
//  Grid MultiSelection Pan Gesture
//
//  Created by Matteo Buompastore on 21/01/25.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    @State private var items: [Item] = []
    @State private var isSelectionEnabled: Bool = false
    @State private var panGesture: UIPanGestureRecognizer?
    @State private var properties: SelectionProperties = .init()
    @State private var scrollProperties: ScrollProperties = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                Text("Grid View")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .trailing) {
                        Button(isSelectionEnabled ? "Cancel" : "Select") {
                            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                isSelectionEnabled.toggle()
                                if !isSelectionEnabled {
                                    properties = .init()
                                }
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    } //: Text Overlay
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
                    ForEach($items) { $item in
                        ItemCardView($item)
                    } //: Loop Items
                } //: Lazy V-GRID
            } //: VSTACK
            .scrollTargetLayout()
        } //: V-SCROLL
        .safeAreaPadding(15)
        .scrollPosition($scrollProperties.position)
        .overlay(alignment: .top) {
            scrollDetectionRegion()
        }
        .overlay(alignment: .bottom) {
            scrollDetectionRegion(false)
        }
        .onAppear {
            createSampleData()
        }
        .onChange(of: isSelectionEnabled, { oldValue, newValue in
            panGesture?.isEnabled = newValue
        })
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentOffset.y + $0.contentInsets.top
        }, action: { oldValue, newValue in
            scrollProperties.currentScrollOffset = newValue
        })
        .onChange(of: scrollProperties.direction, { oldValue, newValue in
            if newValue != .none {
                
                guard scrollProperties.timer == nil else { return }
                
                scrollProperties.manualScrollOffset = scrollProperties.currentScrollOffset
                scrollProperties.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                    if newValue == .up {
                        scrollProperties.manualScrollOffset += 3
                    }
                    if newValue == .down {
                        scrollProperties.manualScrollOffset -= 3
                    }
                    
                    scrollProperties.position.scrollTo(y: scrollProperties.manualScrollOffset)
                })
                scrollProperties.timer?.fire()
            } else {
                resetTimer()
            }
        })
        .gesture(
            PanGesture { gesture in
                if panGesture == nil {
                    panGesture = gesture
                    gesture.isEnabled = isSelectionEnabled
                }
                let state = gesture.state
                
                if state == .began || state == .changed {
                    onGestureChange(gesture)
                } else {
                    onGestureEnded(gesture)
                }
            }
        )
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func ItemCardView(_ binding: Binding<Item>) -> some View {
        let item = binding.wrappedValue
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(item.color.gradient)
                .frame(height: 80)
                .onGeometryChange(for: CGRect.self) {
                    $0.frame(in: .global)
                } action: { newValue in
                    binding.wrappedValue.location = newValue
                }
                .overlay(alignment: .topLeading) {
                    if properties.selectedIndices.contains(index) && !properties.toBeDeletedIndices.contains(index) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.black, .white)
                            .padding(5)
                    }
                }
                .overlay {
                    if isSelectionEnabled {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .contentShape(.rect)
                            .onTapGesture {
                                if properties.selectedIndices.contains(index) {
                                    properties.selectedIndices.removeAll(where: { $0 == index })
                                } else {
                                    properties.selectedIndices.append(index)
                                }
                                
                                properties.previousIndices = properties.selectedIndices
                            }
                    }
                }
        }

    }
    
    /// Scroll Detection Region
    @ViewBuilder
    private func scrollDetectionRegion(_ isTop: Bool = true) -> some View {
        Rectangle()
            .foregroundStyle(.clear)
            .frame(height: 100)
            .ignoresSafeArea()
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action: { newValue in
                if isTop {
                    scrollProperties.topRegion = newValue
                } else {
                    scrollProperties.bottomRegion = newValue
                }
            }

    }
    
    // MARK: Functions
    
    private func onGestureChange(_ gesture: UIPanGestureRecognizer) {
        let position = gesture.location(in: gesture.view)
        if let fallingIndex = items.firstIndex(where: { $0.location.contains(position) }) {
            if properties.start == nil {
                properties.start = fallingIndex
                properties.isDeleteDrag = properties.previousIndices.contains(fallingIndex)
            }
            
            properties.end = fallingIndex
            
            if let start = properties.start, let end = properties.end {
                if properties.isDeleteDrag {
                    let indices = (start > end ? end...start : start...end).compactMap({ $0 })
                    properties.toBeDeletedIndices = Set(properties.previousIndices).intersection(indices).compactMap({ $0 })
                } else {
                    /// In case the user is selecting in reverse order
                    let indices = (start > end ? end...start : start...end).compactMap({ $0 })
                    
                    properties.selectedIndices = Set(properties.previousIndices).union(indices).compactMap({ $0 })
                }
            }
            
            scrollProperties.direction = scrollProperties.topRegion.contains(position) ? .down : scrollProperties.bottomRegion.contains(position) ? .up : .none
        }
    }
    
    private func onGestureEnded(_ gesture: UIPanGestureRecognizer) {
        /// Deleting Indices that must be deleted
        for index in properties.toBeDeletedIndices{
            properties.selectedIndices.removeAll(where: { $0 == index })
        }
        
        properties.toBeDeletedIndices = []
        properties.previousIndices = properties.selectedIndices
        properties.start = nil
        properties.end = nil
        properties.isDeleteDrag = false
        
        resetTimer()
    }
    
    /// Reset Timer
    private func resetTimer() {
        scrollProperties.manualScrollOffset = .zero
        scrollProperties.timer?.invalidate()
        scrollProperties.timer = nil
        scrollProperties.direction = .none
    }
    
    private func createSampleData() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .cyan, .brown, .orange, .pink]
        for _ in 0...4 {
            let sampleItems = colors.shuffled().compactMap({ Item(color: $0) })
            items.append(contentsOf: sampleItems)
        }
    }
    
    
    struct SelectionProperties {
        var start: Int?
        var end: Int?
        var selectedIndices: [Int] = []
        var previousIndices: [Int] = []
        var toBeDeletedIndices: [Int] = []
        var isDeleteDrag: Bool = false
    }
    
    struct ScrollProperties {
        var position: ScrollPosition = .init()
        var currentScrollOffset: CGFloat = 0
        var manualScrollOffset: CGFloat = 0
        var timer: Timer?
        var direction: ScrollDirection = .none
        
        /// Screen Regions
        var topRegion: CGRect = .zero
        var bottomRegion: CGRect = .zero
    }
    
    enum ScrollDirection {
        case up
        case down
        case none
    }
    
}

struct PanGesture: UIGestureRecognizerRepresentable {
    
    var handle: (UIPanGestureRecognizer) -> Void
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        return UIPanGestureRecognizer()
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }
    
    
}


// MARK: Previews

#Preview {
    Home()
}

#Preview("ContentView") {
    ContentView()
}
