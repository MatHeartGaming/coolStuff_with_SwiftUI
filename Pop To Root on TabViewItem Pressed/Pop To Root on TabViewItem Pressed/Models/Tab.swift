//
//  Tab.swift
//  Pop To Root on TabViewItem Pressed
//
//  Created by Matteo Buompastore on 13/02/24.
//

import Foundation

enum Tab: String {
    case home = "Home"
    case settings = "Settings"
    
    var symbolImage: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gearshape"
        }
    }
}
