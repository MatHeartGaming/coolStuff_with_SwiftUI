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
        @Bindable var bindableCordinator = coordinator
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                
                LazyVStack(alignment: .leading, spacing: 0) {
                    
                    Text("Recents")
                        .font(.largeTitle.bold())
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3)) {
                        ForEach($bindableCordinator.items) { $item in
                            GridImageView(item)
                                .id(item.id)
                                .didFrameChange(result: { frame, bounds in
                                    let minY = frame.minY
                                    let maxY = frame.maxY
                                    let height = bounds.height
                                    
                                    if maxY < 0 || minY > height {
                                        item.appeared = false
                                    } else {
                                        item.appeared = true
                                    }
                                })
                                .onDisappear {
                                    item.appeared = false
                                }
                                .onTapGesture {
                                    coordinator.selectedItem = item
                                }
                        } //: Loop items
                    } //: Lazy V-GRID
                    .padding(.vertical, 12)
                } //: Lazy VSTACK
            } //: SCROLL
            .onChange(of: coordinator.selectedItem) { oldValue, newValue in
                if let item = coordinator.items.first(where: { $0.id == newValue?.id }),
                   !item.appeared {
                    /// Scroll to this item, as this is not visible on the screen
                    reader.scrollTo(item.id, anchor: .bottom)
                }
            }
        } //: ScrollView Reader
        .toolbar(.hidden, for: .navigationBar)
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
