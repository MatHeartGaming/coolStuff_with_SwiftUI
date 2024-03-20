//
//  WheelPicker.swift
//  Custom Horizontal Wheel Picker
//
//  Created by Matteo Buompastore on 19/03/24.
//

import SwiftUI

struct WheelPicker: View {
    
    //MARK: - Properties
    var config: Config
    @Binding var value: CGFloat
    
    /// UI
    @State private var isLoaded: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let horizontalPadding = size.width / 2
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    let totalSteps = config.steps * config.count
                    ForEach(0...totalSteps, id: \.self) { index in
                        let remainder = index % config.steps
                        Divider()
                            .background(remainder == 0 ? Color.primary : .gray)
                            .frame(width: 0, height: remainder == 0 ? 20 : 10, alignment: .center)
                            .frame(minHeight: 20, alignment: .bottom)
                            .overlay(alignment: .bottom) {
                                if remainder == 0 && config.showsText {
                                    Text("\((index / config.steps) * config.multiplier)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .textScale(.secondary)
                                        .fixedSize()
                                        .offset(y: 20)
                                }
                            }
                    } //: Loop Steps
                } //: HSTACK
                .frame(height: size.height)
                .scrollTargetLayout()
            } //: SCROLL
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                /// To set inital scroll position
                let position: Int? = isLoaded ? (Int(value) * config.steps / config.multiplier) : nil
                return position
            }, set: { newValue in
                if let newValue {
                    value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
                }
            }))
            .overlay(alignment: .center) {
                Rectangle()
                    .frame(width: 1, height: 40)
                    .padding(.bottom, 20)
            }
            .safeAreaPadding(.horizontal, horizontalPadding)
            .onAppear {
                /// To set inital scroll position
                if !isLoaded {
                    isLoaded = true
                }
            }
        } //: GEOMETRY
    }
    
}

struct Config: Equatable {
    var count: Int
    var steps: Int = 10
    var spacing: CGFloat = 5
    var multiplier: Int = 10
    var showsText: Bool = true
}

#Preview {
    ContentView()
}

#Preview {
    @State var value: CGFloat = 0
    return WheelPicker(config: .init(count: 30), value: $value)
}
