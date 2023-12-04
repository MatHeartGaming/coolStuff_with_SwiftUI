//
//  ImagePicker.swift
//  ParticleEffect
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    
    // MARK: - PROPERTIES
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChanged: (UIImage) -> Void
    
    // MARK: - UI
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?
    /// Preview Image
    @State private var previewImage: UIImage?
    @State private var isLoading = false
    
    
    // MARK: - BODY
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(tint)
                
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
            } //: VSTACK
            /// Displaying preview image, if any
            .opacity(previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .padding(15)
                }
            } //: OVERLAY IMAGE PREVIEW
            /// Loading UI
            .overlay {
                if isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            }
            /// Animating
            .animation(.snappy, value: isLoading)
            .animation(.smooth, value: previewImage)
            .contentShape(.rect)
            /// Drag & Drop action
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    /// Sending the image using callback
                    generateImageThumbnail(droppedImage, size)
                    onImageChanged(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
            .onTapGesture {
                showImagePicker.toggle()
            }
            /// Manual Image picker
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .optionalViewModifier { contentView in
                if #available(iOS 17, *) {
                    contentView
                        .onChange(of: photoItem) { oldValue, newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                } else {
                    contentView
                        .onChange(of: photoItem) { newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                }
            }
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                } //: ZSTACK
            } //: BACKGROUND
        } //: GEOMETRY
    }
    
    
    //MARK: - FUNCTIONS
    
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        isLoading = true
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            // Update UI on the main thread
            
            await MainActor.run {
                previewImage = thumbnailImage
                isLoading = false
            }
        }
    }
    
    /// Extract Image from Photo Item
    func extractImage(_ photoItem: PhotosPickerItem, _ size: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else { return }
            
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    /// Generate preview
                    generateImageThumbnail(selectedImage, size)
                    /// Send original image to Callback
                    onImageChanged(selectedImage)
                }
                
                self.photoItem = nil
            }
        }
        
        
    }
    
}

extension View {
    
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
    
}

#Preview {
    ImagePicker(title: "Title", subTitle: "Subtitle", systemImage: "house", tint: .cyan) { image in
        
    }
}
