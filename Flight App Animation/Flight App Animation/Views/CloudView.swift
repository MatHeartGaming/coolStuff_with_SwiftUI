//
//  CloudView.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

struct CloudView: View {
    
    //MARK: - Properties
    var delay: Double
    var size: CGSize
    @State private var moveCloud = false
    
    var body: some View {
        ZStack {
            
            Image(.cloud)
                .resizable()
                .scaledToFit()
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
            
        } //: ZSTACK
        .onAppear {
            /// Duration = Speed of movement of the Cloud
            withAnimation(.easeInOut(duration: 6.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}

#Preview {
    GeometryReader {
        let size = $0.size
        CloudView(delay: 0.5, size: size)
    }
}

#Preview {
    ContentView()
}
