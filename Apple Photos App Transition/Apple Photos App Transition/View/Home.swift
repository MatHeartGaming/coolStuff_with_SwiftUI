//
//  Home.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - Properties
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3)) {
                ForEach(coordinator.items) { item in
                    GridImageView(item)
                        .onTapGesture {
                            coordinator.selectedItem = item
                        }
                } //: Loop items
                
            } //: Lazy V-GRID
        } //: SCROLL
        .navigationTitle("Recents")
    }
    
    
    // MARK: - Views
    @ViewBuilder
    func GridImageView(_ item: Item) -> some View {
        GeometryReader {
            let size = $0.size
            
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                    return [item.id + "SOURCE": anchor]
                })
            
            if let previewImage = item.previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(coordinator.selectedItem?.id == item.id ? 0 : 1)
                    
            }
        } //: GEOMETYRY
        .frame(height: 130)
        .contentShape(.rect)
    }
    
}

#Preview {
    NavigationStack {
        Home()
            .environment(UICoordinator())
    }
}

#Preview {
    ContentView()
        .environment(UICoordinator())
}
