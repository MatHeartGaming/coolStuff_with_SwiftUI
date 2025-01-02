//
//  ContentView.swift
//  Reduce Images Memory Consumption
//
//  Created by Matteo Buompastore on 02/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    ForEach(1...3, id: \.self) { index in
                        let size = CGSize(width: 100, height: 150)
                        let id = "Pic\(index)"
                        DownsizedImageView(id: id, image: UIImage(named: id), size: size) { image in
                            GeometryReader {
                                let sizeGeom = $0.size
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: sizeGeom.width, height: sizeGeom.height)
                                    .clipShape(.rect(cornerRadius: 10))
                            } //: GEOMETRY
                            .frame(height: size.height)
                        }
                    } //: Loop Images
                } //: HSTACK
                .frame(maxWidth: .infinity)
            } //: LIST
            .navigationTitle("Downsized Image View")
        } //: NAVIGATION
        .padding()
    }
}

struct DownsizedImageView<Content: View>: View {
    
    var id: String
    var image: UIImage?
    var size: CGSize
    
    /// Like AsyncImage works
    @ViewBuilder var content: (Image) -> Content
    
    /// UI
    @State private var downsizingImageView: Image?
    
    var body: some View {
        ZStack {
            
            if let downsizingImageView {
                content(downsizingImageView)
            } else {
                /// Optional
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        } //: ZSTACK
        .onAppear {
            guard downsizingImageView == nil else { return }
            createDownsizedImage(image)
        }
        .onChange(of: image) { oldValue, newValue in
            guard oldValue != newValue else { return }
            createDownsizedImage(newValue)
        }
    }
    
    /// Creating Downsized
    private func createDownsizedImage(_ image: UIImage?) {
        if let cachedData = try? CacheManager.shared.get(id: id)?.data,
           let uiImage = UIImage(data: cachedData) {
            downsizingImageView = Image(uiImage: uiImage)
            print("From Cache")
        } else {
            print("Downsizing...")
            guard let image else { return }
            
            let aspectSize = image.size.aspectFit(size)
            /// Creation of smaller version of the image in separate thread
            Task.detached(priority: .high) {
                let renderer = UIGraphicsImageRenderer(size: aspectSize)
                let resizedImage = renderer.image { ctx in
                    image.draw(in: .init(origin: .zero, size: aspectSize))
                }
                
                /// Storing Cache Data
                if let jpegData = resizedImage.jpegData(compressionQuality: 1) {
                    /// Since CacheManager is MainActor, it should run on MainActor
                    await MainActor.run {
                        try? CacheManager.shared.insert(id: id, data: jpegData, expirationDays: 7)
                    }
                }
                
                /// Update UI in Main Thread
                await MainActor.run {
                    downsizingImageView = Image(uiImage: resizedImage)
                }
            } //: Task
        }
    }
    
}

extension CGSize {
    func aspectFit(_ to: CGSize) -> CGSize {
        let scaleX = to.width / self.width
        let scaleY = to.height / self.height
        
        let aspectRatio = min(scaleX, scaleY)
        return .init(width: aspectRatio * width, height: aspectRatio * height)
    }
}

#Preview {
    ContentView()
}
