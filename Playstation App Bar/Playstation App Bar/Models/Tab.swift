//
//  Tab.swift
//  Playstation App Bar
//
//  Created by Matteo Buompastore on 18/01/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    
    case play = "Play"
    case explore = "Explore"
    case store = "PS Store"
    case library = "Game Library"
    case search = "Search"
    
    var index: CGFloat {
        return CGFloat(Tab.allCases.firstIndex(of: self) ?? 0)
    }
    
    static var count: CGFloat {
        return CGFloat(Tab.allCases.count)
    }
    
}
