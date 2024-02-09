//
//  ContentView.swift
//  StretchySlider
//
//  Created by Matteo Buompastore on 09/02/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var progress: CGFloat = .zero
    @State private var axis: SliderAxis = .vertical
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Picker("", selection: $axis) {
                    Text("Vertical")
                        .tag(SliderAxis.vertical)
                    Text("Horizontal")
                        .tag(SliderAxis.horizontal)
                } //: PICKER Axis
                .pickerStyle(.segmented)
                
                CustomSlider(
                    sliderProgress: $progress,
                    symbol: .init(
                        icon: "airpodspro",
                        tint: .gray,
                        font: .system(size: 25),
                        padding: 20,
                        display: axis == .vertical,
                        alignment: .bottom
                    ),
                    axis: axis,
                    tint: .white
                )
                /// Define an explicit frame size for the Slider. It will make it work as it should.
                .frame(width: axis == .horizontal ? 220 : 60,
                       height: axis == .horizontal ? 50 : 180)
                .frame(maxHeight: .infinity)
                .animation(.snappy, value: axis)
                
                Button("Update") {
                    withAnimation(.smooth) {
                        progress = 0.2
                    }
                }
                
            } //: VSTACK
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Stretchy Slider")
            .background(.fill)
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
