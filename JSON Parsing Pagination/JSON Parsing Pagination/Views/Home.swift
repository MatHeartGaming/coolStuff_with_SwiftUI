//
//  Home.swift
//  JSON Parsing Pagination
//
//  Created by Matteo Buompastore on 25/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    
    //MARK: - Properties
    @State private var photos: [Photo] = []
    @State private var page: Int = 1
    @State private var lastFetchedPage: Int = 1
    @State private var isLoading: Bool = false
    @State private var maxPage: Int = 5
    
    /// Pagination properties
    @State private var activePhotoID: String?
    @State private var lastPhotoID: String?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                ForEach(photos) { photo in
                    PhotoCardView(photo: photo)
                } //: Loop Photos
            } //: V-GRID
            .overlay(alignment: .bottom) {
                if isLoading {
                    ProgressView()
                        .offset(y: 30)
                }
            }
            .padding(15)
            .padding(.bottom, 15)
            .scrollTargetLayout()
        } //: SCROLL
        .scrollPosition(id: $activePhotoID, anchor: .bottomTrailing)
        .onChange(of: activePhotoID, { oldValue, newValue in
            if newValue == lastPhotoID, !isLoading, page <= maxPage {
                page += 1
                fetchPhotos()
            }
        })
        .onAppear {
            if photos.isEmpty {
                fetchPhotos()
            }
        }
    }
    
    
    //MARK: - Functions
    private func fetchPhotos() {
        Task {
            do {
                if let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") {
                    isLoading = true
                    let session = URLSession(configuration: .default)
                    let jsonData = try await session.data(from: url).0
                    let photos = try JSONDecoder().decode([Photo].self, from: jsonData)
                    /// Update UI
                    await MainActor.run {
                        if photos.isEmpty {
                            /// No more data
                            page = lastFetchedPage
                            maxPage = lastFetchedPage
                        } else {
                            self.photos.append(contentsOf: photos)
                            lastPhotoID = self.photos.last?.id
                            lastFetchedPage = page
                        }
                        
                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                page = lastFetchedPage
                print(error.localizedDescription)
            }
        }
    }
    
}

/// Photo Card
struct PhotoCardView: View {
    
    var photo: Photo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { proxy in
                let size = proxy.size
                
                AnimatedImage(url: photo.imageURL) {
                    ProgressView()
                        /// Place at the center
                        .frame(width: size.width, height: size.height)
                }
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 10, style: .continuous))
            } //: GEOMETRY
            .frame(height: 120)
            
            Text(photo.author)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(1)
            
        } //: VSTACK
    }
}

#Preview {
    Home()
}
