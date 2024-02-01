//
//  Home.swift
//  Photo Editor Cropping Tool
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - Properties
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if let croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                } else {
                    Text("No Image Selected")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            } //: VSTACK
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showPicker.toggle()
                    }, label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                    }) //: Button
                    .tint(.black)
                }
            } //: Toolbar
            .cropImagePicker(options: [.circle, .square,
                                       .rectangle, .custom(CGSize(width: 600, height: 550))],
                             show: $showPicker,
                             croppedImage: $croppedImage)
            
        } //: NAVIGATION
    }
}

#Preview {
    Home()
}
