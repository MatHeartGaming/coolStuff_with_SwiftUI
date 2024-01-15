//
//  ContentView.swift
//  CoverFlow With Reflections
//
//  Created by Matteo Buompastore on 15/01/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @State private var items: [CoverFlowItem] = [.red, .blue, .green, .yellow].compactMap { color in
            .init(color: color)
    }
    
    /// View
    @State private var spacing: CGFloat = 0
    @State private var rotation: CGFloat = 0
    @State private var enableReflection = false
    @AppStorage("isDark") private var isDark = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CoverFlowView(itemWidth: 250,
                              enableReflections: enableReflection,
                              spacing: spacing,
                              rotation: rotation,
                              items: items) { item in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(item.color.gradient)
                }
                .frame(height: 180)
                
                Spacer(minLength: 0)
                
                /// Customization VIew
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Toggle Reflection", isOn: $enableReflection)
                    
                    Toggle("Dark Mode", isOn: $isDark)
                    
                    Text("Card Spacing")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Slider(value: $spacing, in: -120...90)
                    
                    Text("Card Rotation")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Slider(value: $rotation, in: 0...190) // <-- Limit to 90° to avoid view flipping
                }
                .padding(15)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .padding(15)
                
            } //: VSTACK
            .navigationTitle("CoverFlow")
        } //: NAVIGATION
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
