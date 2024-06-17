//
//  ZoomTransitions.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

struct ZoomTransitions: View {
    
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                    ForEach(sampleItems) { item in
                        NavigationLink(value: item) {
                            GeometryReader {
                                let size = $0.size
                                
                                if let image = item.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size.width, height: size.height)
                                        .clipShape(.rect(cornerRadius: 20))
                                }
                            } //: GEOMETRY
                            .frame(height: 150)
                            /// Use this new modifier on the Source View
                            .matchedTransitionSource(id: item.id, in: animation) { config in
                                config
                                    .background(.clear)
                                    .clipShape(.rect(cornerRadius: 20))
                            }
                        } //: NAV LINK
                        .contentShape(.rect(cornerRadius: 20))
                        .buttonStyle(.plain)
                    } //: Loop
                } //: Lazy VGRID
                .padding(15)
            } //: V-SCROLL
            .navigationTitle("Home")
            .navigationDestination(for: Item.self) { item in
                /// Detail View
                GeometryReader {
                    let size = $0.size
                    if let image = item.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.width)
                    }
                } //: GEOMETRY
                .padding(20)
                .navigationTitle(item.title)
                .navigationBarTitleDisplayMode(.inline)
                /// Use this new modifier on the Destination View
                .navigationTransition(.zoom(sourceID: item.id, in: animation))
            }
        } //: NAVIGATION
    }
}

struct Item: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let image: UIImage?
}

var sampleItems: [Item] = [
    Item(title: "Item 1", image: UIImage(named: "Pic 1")),
    Item(title: "Item 2", image: UIImage(named: "Pic 2")),
    Item(title: "Item 3", image: UIImage(named: "Pic 3")),
    Item(title: "Item 4", image: UIImage(named: "Pic 4")),
    Item(title: "Item 5", image: UIImage(named: "Pic 5")),
]



#Preview {
    ZoomTransitions()
}
