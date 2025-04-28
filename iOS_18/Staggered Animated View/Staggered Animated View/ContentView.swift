//
//  ContentView.swift
//  Staggered Animated View
//
//  Created by Matteo Buompastore on 28/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    Button("Toggle") {
                        showView.toggle()
                    }
                    
                    let config = StaggeredConfig(
                        offset: .zero,
                        scale: 0.85,
                        scaleAnchor: .center
                    )
                    
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        StaggeredView(config: config) {
                            if showView {
                                ForEach(1...10, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.black.gradient)
                                        .frame(height: 150)
                                }
                            }
                        }
                    }
                    
                    //Spacer(minLength: 0)
                } //: VSTACK
                .padding(15)
                .frame(maxWidth: .infinity)
            } //: SCROLL
            .navigationTitle("Staggered View")
            .navigationBarTitleDisplayMode(.inline)
        } //: NAVIGATION
    }
    
    @ViewBuilder
    func DummyView() -> some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 10)
                    .padding(.trailing, 20)
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 10)
                    .padding(.trailing, 140)
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100, height: 10)
            }
        }
        .foregroundStyle(.gray.opacity(0.7).gradient)
    }
}

#Preview {
    ContentView()
}
