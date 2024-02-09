//
//  CustomSlider.swift
//  StretchySlider
//
//  Created by Matteo Buompastore on 09/02/24.
//

import SwiftUI

struct CustomSlider: View {
    
    // MARK: - Properties
    @Binding var sliderProgress: CGFloat
    
    /// Configs
    let symbol: Symbol?
    var axis: SliderAxis
    var tint: Color
    
    /// To limit the stretchability of the slider
    var stretchabilityPercentageLimit: CGFloat = 0.15
    var limitMaximumStretch: Bool = false
    
    /// UI
    @State private var progress: CGFloat = .zero
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader {
            
            let size = $0.size
            let orientationSize = axis == .horizontal ? size.width : size.height
            let progressValue = max(progress, .zero) * orientationSize
            
            ZStack(alignment: axis == .horizontal ? .leading : .bottom) {
                Rectangle()
                    .fill(.fill)
                
                Rectangle()
                    .fill(tint)
                    .frame(width: axis == .horizontal ? progressValue : nil,
                           height: axis == .vertical ? progressValue : nil)
                
                if let symbol, symbol.display {
                    Image(systemName: symbol.icon)
                        .font(symbol.font)
                        .foregroundStyle(symbol.tint)
                        .padding(symbol.padding)
                        .frame(width: size.width, height: size.height, alignment: symbol.alignment)
                }
                
            } //: ZSTACK
            .clipShape(.rect(cornerRadius: 15, style: .continuous))
            .contentShape(.rect(cornerRadius: 15, style: .continuous))
            .optionalSizingModifers(
                axis: axis,
                size: size,
                progress: progress,
                orientationSize: orientationSize
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        let translation = value.translation
                        let movement = (axis == .horizontal ? translation.width : -translation.height) + lastDragOffset
                        dragOffset = movement
                        calculateProgress(orientationSize: orientationSize)
                    })
                    .onEnded({ value in
                        withAnimation(.smooth) {
                            dragOffset = dragOffset > orientationSize ? orientationSize : (dragOffset < 0 ? 0 : dragOffset)
                            calculateProgress(orientationSize: orientationSize)
                        }
                        lastDragOffset = dragOffset
                    })
            ) //: Gesture
            .frame(maxWidth: size.width, 
                   maxHeight: size.height,
                   alignment: axis == .vertical ? (progress < 0 ? .top : .bottom) : (progress < 0 ? .trailing : .leading))
            .onChange(of: sliderProgress, initial: true) { oldValue, newValue in
                /// Initali progress setting
                guard sliderProgress != progress,
                        (sliderProgress > 0 && sliderProgress < 1)
                else { return }
                
                progress = max(min(sliderProgress, 1), 0)
                dragOffset = progress * orientationSize
                lastDragOffset = dragOffset
            } //: OnChange SliderProgress
            .onChange(of: axis) { oldValue, newValue in
                dragOffset = progress * orientationSize
                lastDragOffset = dragOffset
            }
            .onChange(of: progress) { oldValue, newValue in
                sliderProgress = max(min(progress, 1), 0)
            }
            
        } //: GEOMETRY
    }
    
    
    //MARK: - Functions
    
    private func calculateProgress(orientationSize: CGFloat) {
        let topAndTrailingExcessOffset = orientationSize + (dragOffset - orientationSize) * stretchabilityPercentageLimit
        let bottomAndLeadingExcessOffset = dragOffset < 0 ? (dragOffset * stretchabilityPercentageLimit) : dragOffset
        let progress = (dragOffset > orientationSize ? topAndTrailingExcessOffset : bottomAndLeadingExcessOffset) / orientationSize
        self.progress = (limitMaximumStretch && progress > 1.1) ? 1.1 : progress
        
    }
    
}

fileprivate extension View {
    
    @ViewBuilder
    func optionalSizingModifers(axis: SliderAxis, size: CGSize, progress: CGFloat, orientationSize: CGFloat, scalePercentageLimit: CGFloat = 0.35) -> some View {
        let topAndTrailingScale = 1 - (progress - 1) * scalePercentageLimit
        let bottomAndLeadingScale = 1 + (progress) * scalePercentageLimit
        self
            .frame(width: axis == .horizontal && progress < 0 ? size.width + (-progress * size.width) : nil,
                   height: axis == .vertical && progress < 0 ? size.height + (-progress * size.height) : nil)
            .scaleEffect(x: axis == .vertical ? (progress > 1 ? topAndTrailingScale : (progress < 0 ? bottomAndLeadingScale : 1)) : 1,
                         y: axis == .horizontal ? (progress > 1 ? topAndTrailingScale : (progress < 0 ? bottomAndLeadingScale : 1)) : 1,
                         anchor: axis == .horizontal ? (progress < 0 ? .trailing : .leading) : (progress < 0 ? .top : .bottom)
            )
    }
    
}

#Preview {
    @State var sliderProgress: CGFloat = .zero
    var axis: SliderAxis = .horizontal
    return CustomSlider(
        sliderProgress: $sliderProgress,
        symbol: .init(
            icon: "airpodspro",
            tint: .gray,
            font: .system(
                size: 25
            ),
            padding: 20
        ),
        axis: axis,
        tint: .black.opacity(0.8),
        stretchabilityPercentageLimit: 0.15,
        limitMaximumStretch: false
    )
    .frame(width: axis == .horizontal ? 220 : 60,
           height: axis == .horizontal ? 50 : 180)
    .frame(maxHeight: .infinity)
}

#Preview(body: {
    ContentView()
})
