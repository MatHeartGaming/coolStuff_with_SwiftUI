//
//  ContentView.swift
//  Chips Layout iOS 18 API
//
//  Created by Matteo Buompastore on 20/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sliderValue: CGFloat = 180
    
    var body: some View {
        NavigationStack {
            VStack {
                ChipsView(sliderValue: $sliderValue) {
                    ForEach(mockChips) { chip in
                        
                        /// 20 is the horizontal padding
                        let viewWidth = chip.name.size(.preferredFont(forTextStyle: .body)).width + 20
                        
                        Text(chip.name)
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(.red.gradient, in: .capsule)
                            .containerValue(\.viewWidth, viewWidth)
                    } //: Loop Chips
                } //: Chips View
                .frame(width: 300)
                .padding(15)
                .background(.primary.opacity(0.06), in: .rect(cornerRadius: 10))
                .animation(.smooth(duration: 0.2), value: sliderValue)
                
                Slider(value: $sliderValue, in: 100...300)
                    .padding(.top)
                Text("\(sliderValue)")
            } //: VSTACK
            .padding(15)
            .navigationTitle("Chips")
        } //: NAVIGATION
    }
}

extension String {
    
    func size(_ font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attributes)
    }
}

extension ContainerValues {
    /// Entry has been introduced with iOS 18 to easily create Environment and Container values
    @Entry var viewWidth: CGFloat = 0
}

struct ChipsView<Content: View>: View {
    
    @Binding var sliderValue: CGFloat
    @ViewBuilder var content: Content
    
    var body: some View {
        Group(subviews: content) { collection in
            let chunkedCollection = collection.chunkedByWidth(sliderValue)
            VStack(alignment: .center, spacing: 10) {
                ForEach(chunkedCollection.indices, id: \.self) { index in
                    HStack(spacing: 10) {
                        ForEach(chunkedCollection[index]) { subview in
                            let viewWidth = subview.containerValues.viewWidth
                            //let _ = print(viewWidth)
                            subview
                        } //: Loop Subviews
                    } //: HSTACK
                } //: Loop Chunked Collection
            } //: VSTACK
        } //: Group Chips
    }
    
}

extension SubviewsCollection {
    
    /// To divide subviews according to the max number of itmes that can fit
    func chunkedByWidth(_ containerWidth: CGFloat) -> [[Subview]] {
        var row: [Subview] = []
        var rowWidth: CGFloat = 0
        var rows: [[Subview]] = []
        let spacing: CGFloat = 10
        
        for subview in self {
            let viewWidth = subview.containerValues.viewWidth + spacing
            rowWidth += viewWidth
            
            if rowWidth < containerWidth {
                row.append(subview)
            } else {
                rows.append(row)
                row = [subview]
                rowWidth = viewWidth
            }
        }
        
        if !row.isEmpty {
            rows.append(row)
        }
        
        return rows
    }
    
    func chunked(_ size: Int) -> [[Subview]] {
        /// This will split a single array into chunks of multiple arrays with the specified size
        return stride(from: 0, to: count, by: size).map { index in
            Array(self[index..<Swift.min(index + size, count)])
        }
    }
}

struct Chip: Identifiable {
    let id: String = UUID().uuidString
    var name: String
}

var mockChips: [Chip] = [
    .init(name: "Apple"),
    .init(name: "Google"),
    .init(name: "Microsoft"),
    .init(name: "Amazon"),
    .init(name: "Facebook"),
    .init(name: "Twitter"),
    .init(name: "Netflix"),
    .init(name: "Youtube"),
    .init(name: "Instagram"),
    .init(name: "Snapchat"),
    .init(name: "Pinterest"),
    .init(name: "TikTok"),
    .init(name: "Reddit"),
    .init(name: "Discord"),
    .init(name: "Uber"),
]

#Preview {
    ContentView()
}
