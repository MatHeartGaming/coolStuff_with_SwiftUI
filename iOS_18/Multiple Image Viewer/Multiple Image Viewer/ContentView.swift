//
//  ContentView.swift
//  Multiple Image Viewer
//
//  Created by Matteo Buompastore on 02/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /// NavigationStack is a must since this is using the Zoom Transition API
        NavigationStack {
            VStack {
                
                ImageViewer {
                    ForEach(sampleImages) { image in
                        /// Animation will work even when images are loading
                        AsyncImage(url: URL(string: image.link)) { image in
                            image
                                .resizable()
                            /// Fit and resizing will be done inside the Viewer
                        } placeholder: {
                            Rectangle()
                                .fill(.gray.opacity(0.4))
                                .overlay {
                                    ProgressView()
                                        .tint(.blue)
                                        .scaleEffect(0.7)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                        } //: Async Image
                        .containerValue(\.activeViewID, image.id)
                    } //: Loop Images
                } overlay: {
                    Overlay()
                } updates: { isPresented, activeViewId in
                    print(isPresented, activeViewId as Any)
                } //: ImageViewer
                
            } //: VSTACK
            .padding(15)
            .navigationTitle("Image Viewer")
        } //: NAVIGATION
    }
}

struct Overlay: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(10)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .padding(15)
    }
}

#Preview {
    ContentView()
}
