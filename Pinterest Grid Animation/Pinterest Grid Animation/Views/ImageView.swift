//
//  ImageView.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 08/05/24.
//

import SwiftUI

struct ImageView: View {
    
    //MARK: - Properties
    var post: Item
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            if let image = post.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            }
        }
    }
}

#Preview {
    ImageView(post: sampleImages.first!)
}
