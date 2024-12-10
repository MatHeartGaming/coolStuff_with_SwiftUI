//
//  CustomSlider.swift
//  Expandable Custom Slider
//
//  Created by Matteo Buompastore on 10/12/24.
//

import SwiftUI

struct CustomSlider<Overlay: View>: View {
    
    // MARK: Properties
    @Binding var value: CGFloat
    var range: ClosedRange<CGFloat>
    var config: Config
    var overlay: Overlay
    
    init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, config: Config = .init(), @ViewBuilder overaly: @escaping () -> Overlay) {
        self._value = value
        self.range = range
        self.config = config
        self.overlay = overaly()
        self.lastStoredValue = value.wrappedValue
    }
    
    /// UI
    @State private var lastStoredValue: CGFloat
    @GestureState private var isActive: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = (value / range.upperBound) * size.width
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(config.inactiveTint)
                
                Rectangle()
                    .fill(config.activeTint)
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                    }
                
                ZStack(alignment: .leading) {
                    overlay
                        .foregroundStyle(config.overalyInactiveTint)
                    overlay
                        .foregroundStyle(config.overalayActiveTint)
                        .mask(alignment: .leading) {
                            Rectangle()
                                .frame(width: width)
                        }
                } //: ZSTACK
                .compositingGroup()
                .animation(.easeInOut(duration: 0.3).delay(isActive ? 0.12 : 0).speed(isActive ? 1 : 2)) {
                    $0.opacity(isActive ? 1 : 0)
                }
                
            } //: ZSTACK
            //.clipShape(.rect(cornerRadius: config.cornerRadius))
            .contentShape(.rect)
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isActive) { _, out, _ in
                        out = true
                    }
                    .onChanged{ value in
                        let progress = ((value.translation.width / size.width) * range.upperBound) + lastStoredValue
                        self.value = max(min(progress, range.upperBound), range.lowerBound)
                    }.onEnded { _ in
                        lastStoredValue = value
                    }
            )
        } //: GEOMETRY
        .frame(height: 20 + config.extraHeight)
        .mask {
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .frame(height: 20 + (isActive ? config.extraHeight : 0))
        }
        .animation(.snappy, value: isActive)
    }
    
    struct Config {
        var inactiveTint: Color = .black.opacity(0.06)
        var activeTint: Color = Color.primary
        var cornerRadius: CGFloat = 15
        var extraHeight: CGFloat = 25
        /// Overlay Properties
        var overalayActiveTint: Color = .white
        var overalyInactiveTint: Color = .black
    }
    
}

#Preview {
    ContentView()
}
