//
//  ContentView.swift
//  Compositional Grid Layout
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var count: Int = 3
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 6) {
                    
                    PickerView()
                        .padding(.bottom, 10)
                    
                    CompositionalLayout(count: count) {
                        ForEach(1...50, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black.gradient)
                                .overlay {
                                    Text("\(index)")
                                        .font(.largeTitle.bold())
                                        .foregroundStyle(.white)
                                }
                        } //: Loop
                    } //: Compositional
                    .animation(.bouncy, value: count)
                } //: Lazy VSTACK
                .padding(15)
            } //: V-SCROLL
            .navigationTitle("Compositional Grid")
        } //: NAVIGATION
    }
    
    // MARK: Views
    
    @ViewBuilder
    private func PickerView() -> some View {
        Picker("", selection: $count) {
            ForEach(1...4, id: \.self) {
                Text("Count = \($0)")
                    .tag($0)
            }
        } //: Picker
        .pickerStyle(.segmented)
    }
    
}

#Preview {
    ContentView()
}
