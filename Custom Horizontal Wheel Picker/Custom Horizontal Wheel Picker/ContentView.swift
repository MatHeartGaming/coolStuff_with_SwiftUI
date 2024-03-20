//
//  ContentView.swift
//  Custom Horizontal Wheel Picker
//
//  Created by Matteo Buompastore on 19/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var value: CGFloat = 10
    @State private var config = Config(count: 30, steps: 5, spacing: 10, multiplier: 10)
    @State private var count: Int = 10
    @State private var steps: Int = 5
    @State private var multiplier: Int = 1
    @State private var spacing: CGFloat = 10
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    //let lbs = CGFloat(config.steps) * CGFloat(value)
                    Text(verbatim: "\(value)")
                        .font(.largeTitle.bold())
                        .contentTransition(.numericText(value: value))
                        .animation(.snappy, value: value)
                    Text("lbs")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                } //: HSTACK
                .padding(.bottom)
                
                WheelPicker(config: config, value: $value)
                    .frame(height: 60)
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Count")
                            .font(.caption)
                        Picker("Count", selection: $count) {
                            Text("10")
                                .tag(10)
                            Text("20")
                                .tag(20)
                            Text("30")
                                .tag(30)
                        } //: Picker
                        .pickerStyle(.segmented)
                        .padding(.bottom, 20)
                        
                        Text("Steps")
                            .font(.caption)
                        Picker("Steps", selection: $steps) {
                            Text("5")
                                .tag(5)
                            Text("10")
                                .tag(10)
                        } //: Picker
                        .pickerStyle(.segmented)
                        .padding(.bottom, 20)
                        
                        Text("Multiplier")
                            .font(.caption)
                        Picker("Multiplier", selection: $multiplier) {
                            Text("1")
                                .tag(1)
                            Text("10")
                                .tag(10)
                        } //: Picker
                        .pickerStyle(.segmented)
                        .padding(.bottom, 20)
                        
                        Text("Spacing")
                            .font(.caption)
                        Slider(value: $spacing, in: 10...100) {
                            Text("Spacing")
                        } onEditingChanged: { _ in
                            withAnimation(.smooth) {
                                config.spacing = spacing
                            }
                        }
                        
                    } //: VSTACK
                    .padding()
                } //: Section
                .background(.regularMaterial, in: .rect(cornerRadius: 15, style: .continuous))
                .padding()
                .padding(.top, 30)
                .onChange(of: count) { oldValue, newValue in
                    withAnimation(.snappy) {
                        config.count = count
                    }
                }
                .onChange(of: steps) { oldValue, newValue in
                    withAnimation(.snappy) {
                        config.steps = steps
                    }
                }
                .onChange(of: multiplier) { oldValue, newValue in
                    withAnimation(.snappy) {
                        config.multiplier = multiplier
                    }
                }
                
            } //: VSTACK
            .navigationTitle("Wheel Picker")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
