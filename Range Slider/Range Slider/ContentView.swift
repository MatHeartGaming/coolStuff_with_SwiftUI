//
//  ContentView.swift
//  Range Slider
//
//  Created by Matteo Buompastore on 26/04/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var selection: ClosedRange<CGFloat> = 60...90
    
    var body: some View {
        NavigationStack {
            VStack {
                RangeSliderView(
                    selection: $selection, 
                    range: 10...100,
                    minimumDistance: 10
                )
                
                Text("\(Int(selection.lowerBound)): \(Int(selection.upperBound))")
                    .font(.largeTitle.bold())
                    .padding(.top, 10)
            } //: VSTACK
            .padding()
            .navigationTitle("Range Slider")
        } //: NAVIGATION
    }
}

struct RangeSliderView: View {
    
    //MARK: - Properties
    @Binding var selection: ClosedRange<CGFloat>
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .primary
    
    /// UI
    @State private var slider1: GestureProperties = .init()
    @State private var slider2: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    @State private var isInital: Bool = false
    
    init(selection: Binding<ClosedRange<CGFloat>>, range: ClosedRange<CGFloat>, minimumDistance: CGFloat = 0, tint: Color = .primary) {
        self._selection = selection
        self.range = range
        print("\(range.upperBound - range.lowerBound)")
        if minimumDistance > (range.upperBound - range.lowerBound) {
            self.minimumDistance = 0
            print("Was higher")
        } else {
            self.minimumDistance = minimumDistance
            print("Was OK")
        }
        self.tint = tint
    }
    
    var body: some View {
        GeometryReader { reader in
            
            /// 30 is the total width of both sliders
            let maxSliderWidth = reader.size.width - 30
            let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(tint.tertiary)
                    .frame(height: 5)
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(tint)
                                .frame(width: indicatorWidth, height: 5)
                                .offset(x: 15)
                                .allowsHitTesting(false)
                        }
                        .offset(x: slider1.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    /// Calculating Offset
                                    var translation = value.translation.width + slider1.lastStoredOffset
                                    translation = min(max(translation, 0), slider2.offset - minimumDistance)
                                    slider1.offset = translation
                                    
                                    calculateNewRange(reader.size)
                                }
                                .onEnded { _ in
                                    /// Storing previous offset
                                    slider1.lastStoredOffset = slider1.offset
                                }
                        )
                    
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .offset(x: slider2.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    /// Calculating Offset
                                    var translation = value.translation.width + slider2.lastStoredOffset
                                    translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                                    slider2.offset = translation
                                    
                                    calculateNewRange(reader.size)
                                }
                                .onEnded { _ in
                                    /// Storing previous offset
                                    slider2.lastStoredOffset = slider2.offset
                                }
                        )
                    
                } //: HSTACK
            } //: ZSTACK
            .frame(maxHeight: .infinity)
            .task {
                guard !isInital else { return }
                isInital = true
                try? await Task.sleep(for: .seconds(0))
                let maxWidth = reader.size.width - 30
                
                /// Converting selection range into offset
                let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                
                slider1.offset = start
                slider1.lastStoredOffset = start
                
                slider2.offset = end
                slider2.lastStoredOffset = end
                
                calculateNewRange(reader.size)
            }
        } //: GEOMETRY
        .frame(height: 20)
    }
    
    
    // MARK: - Functions
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset
        
        /// Calculating New Range Values
        let maxWidth = size.width - 30
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth
        
        /// Interpolating betweeen upper and lower bounds
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        
        selection = newRangeStart...newRangeEnd
    }
    
    struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoredOffset: CGFloat = 0
    }
    
}


/// Inrerpolation
extension CGFloat {
    
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        /// If Value less than it's Initial Input Range
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return outputRange[0] }
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            /// Linear Interpolation Formula: y1 + ((y2-y1) / (x2-x1)) * (x-x1)
            if x <= inputRange[index] {
                let y = y1 + ( (y2-y1) / (x2-x1)) * (x-x1)
                return y
            }
        }
        /// If Value Exceeds it's Maximum Input Range return outputRange[length]
        return outputRange[length]
    }
}


#Preview {
    ContentView()
}
