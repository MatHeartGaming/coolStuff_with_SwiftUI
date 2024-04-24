//
//  TabModel.swift
//  Scrollable Tab Bar
//
//  Created by Matteo Buompastore on 24/04/24.
//

import SwiftUI

struct TabModel: Identifiable {
    
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    enum Tab: String, CaseIterable {
        case research = "Reasearch"
        case deployment = "Deployment"
        case analytics = "Analytics"
        case audience = "Audience"
        case privacy = "Privacy"
    }
    
}
