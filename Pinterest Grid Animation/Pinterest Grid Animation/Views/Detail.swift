//
//  Detail.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

struct Detail: View {
    
    //MARK: - Properties
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let animateView = coordinator.animateView
            let hideView = coordinator.hideRootView
            let hideLayer = coordinator.hideLayer
            /// if the anchor is less than 0.5 it is on the leading side, otherrwise on the trailing side. This only works for 2 columns.
            let anchorX: CGFloat = (coordinator.rect.minX / size.width) > 0.5 ? 1 : 0
            let scale = coordinator.rect.width / size.width
            
            if let image = coordinator.animationLayer {
                Image(uiImage: image)
                    .scaleEffect(animateView ? scale : 1,
                                 anchor: .init(x: animateView ? anchorX : 1, y: 0))
            }
        } //: GEOMETRY
        .ignoresSafeArea()
    }
}

#Preview {
    Detail()
        .environment(UICoordinator())
}
