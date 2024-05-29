//
//  Tab.swift
//  TabView Offset Reader
//
//  Created by Matteo Buompastore on 29/05/24.
//

import SwiftUI

enum DummyTab: String, CaseIterable {
    
    case home = "Home"
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var color: Color {
        switch self {
        case .home:
            return .red
        case .chats:
            return .blue
        case .calls:
            return .black
        case .settings:
            return .purple
        }
    }
    
}
