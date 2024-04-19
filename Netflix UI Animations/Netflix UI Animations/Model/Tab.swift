//
//  Tab.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case new = "New & Hot"
    case account = "My Netflix"
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .new:
            return "play.rectangle.on.rectangle.fill"
        case .account:
            return "Profile"
        }
    }
}
