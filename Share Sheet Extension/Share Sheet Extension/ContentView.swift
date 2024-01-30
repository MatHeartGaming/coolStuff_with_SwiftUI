//
//  ContentView.swift
//  Share Sheet Extension
//
//  Created by Matteo Buompastore on 30/01/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query private var allItems: [ImageItem]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(allItems) { item in
                        CardView(item: item)
                            .frame(height: 250)
                    } //: Loop Images
                } //: LAZY VSTACK
                .padding(15)
            } //: V-SCROLL
            .navigationTitle("Favourites")
        } // NAVIGATION
    }
}

struct CardView: View {
    
    //MARK: - Properties
    var item: ImageItem
    @State private var previewImage: UIImage?
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            if let previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)
            } else {
                ProgressView()
                    .frame(width: size.width, height: size.height)
                    .task {
                        Task.detached(priority: .high) {
                            /// Use  compressed size for thumbnails
                            let thumbnail = await UIImage(data: item.data)?.byPreparingThumbnail(ofSize: size)
                            await MainActor.run {
                                previewImage = thumbnail
                            }
                        }
                    }
            }
            
        }
    }
    
}

#Preview {
    ContentView()
}
