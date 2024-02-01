//
//  CustomImagePicker.swift
//  Photo Editor Cropping Tool
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI
import PhotosUI

extension View {
    
    @ViewBuilder
    func cropImagePicker(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    /// Haptic Feedback
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
}

struct CustomImagePicker<Content: View>: View {
    
    //MARK: - Properties
    var content: Content
    var options: [Crop]
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    
    init(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>,  @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.options = options
        self._show = show
        self._croppedImage = croppedImage
    }
    
    /// UI
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .circle
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { newValue in
                /// Extracting UIImage From photos item
                if let newValue {
                    Task {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self),
                           let image = UIImage(data: imageData) {
                            /// Update UI on the Main Thread
                            await MainActor.run {
                                selectedImage = image
                                showDialog.toggle()
                            }
                        }
                    }
                }
            } //: On Change photosItem
            .confirmationDialog("", isPresented: $showDialog) {
                /// Displaying All the options
                ForEach(options.indices, id: \.self) { index in
                    Button(options[index].name()) {
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView, onDismiss: {
                /// When exiting clear the old image
                selectedImage = nil
            }, content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            })
    }
}

fileprivate struct CropView: View {
    
    //MARK: - Propeties
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> Void
    
    /// UI
    @Environment(\.dismiss) private var dismiss
    
    /// Gesture
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack {
            ImageView()
                .navigationTitle("Crop View")
                .navigationBarTitleDisplayMode(.inline)
                /// Setting Navigation Bar Background Color
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            /// Converting View to Image (Native iOS 16+)
                            let renderer = ImageRenderer(content: ImageView(hideGrids: true))
                            renderer.proposedSize = .init(crop.size())
                            if let image = renderer.uiImage {
                                onCrop(image, true)
                            } else {
                                onCrop(nil, false)
                            }
                            dismiss()
                        }, label: {
                            Image(systemName: "checkmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        })
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        })
                    }
                } //: Toolbar
        } //: NAVIGATION
    }
    
    @ViewBuilder
    private func ImageView(hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .onTapGesture(count: 2) {
                        reset()
                    }
                    .overlay {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    /// True: dragging
                                    /// False: Stopped dragging
                                    ///With the help of GeometryReader we can now read the minX/Y, maxX/Y of the Image
                                    
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        /// Left Overflow
                                        if rect.minX > 0 {
                                            /// Resetting to Last Location
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        
                                        /// Top Overflow
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        
                                        /// Right Overflow
                                        if rect.maxX < size.width {
                                            /// Resetting to Last Location
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        
                                        /// Bottom Overflow
                                        if rect.maxY < size.width {
                                            /// Resetting to Last Location
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    
                                    if !newValue {
                                        /// Storing LastOffset
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    }
                    .frame(size)
            }
        } //: GEOMETRY
        .scaleEffect(scale)
        .offset(offset)
        .overlay {
            if !hideGrids {
                Grids()
            }
        }
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width,
                                    height: translation.height + lastStoredOffset.height)
                })
        ) //: Drag Gesture
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let updatedScale = value + lastScale
                    /// Setting mimum scale to 1
                    scale = max(updatedScale, 1)
                })
                .onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        ) //: Magnification Gesture
        .frame(cropSize)
        .clipShape(.rect(cornerRadius: crop == .circle ? cropSize.height / 2 : 0))
    }
    
    @ViewBuilder
    private func Grids() -> some View {
        ZStack {
            
            /// Vertical Lines
            HStack {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                } //: H-Loop
            } //: HSTACK
            
            /// Horizontal Lines
            VStack {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                } //: V-Loop
            } //: VSTACK
            
        } //: ZSTACK
    }
    
    private func reset() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.6)) {
            offset = .zero
            lastStoredOffset = .zero
            scale = 1
            lastScale = .zero
        }
    }
    
}

#Preview {
    ContentView()
}

#Preview {
    CropView(crop: .square, image: .sample) { _, _ in
        
    }
}

#Preview {
    CustomImagePicker(options: [.circle, .square, .rectangle], show: .constant(true), croppedImage: .constant(UIImage(named: "sample"))) {
        
    }
}
