//
//  Page.swift
//  Shape Morphing Effect
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

enum Page: String, CaseIterable {
    case page1 = "playstation.logo"
    case page2 = "gamecontroller.fill"
    case page3 = "link.icloud.fill"
    case page4 = "text.bubble.fill"
    
    var title: String {
        switch self {
        case .page1:
            return "Welcome to Playstation®️"
        case .page2:
            return "DualSense®️ Wireless controller"
        case .page3:
            return "Playstation®️ Remote Play"
        case .page4:
            return "Connect with People"
        }
    }
    
    var subtitle: String {
        switch self {
        case .page1:
            return "Playstation®️ is the ultimate gaming experience."
        case .page2:
            return "DualSense® wireless controller for immersive gaming."
        case .page3:
            return "PlayStation®️ Remote Play lets you play games with friends and family."
        case .page4:
            return "Connect with friends and family through PlayStation®️."
        }
    }
    
    var index: CGFloat {
        switch self {
        case .page1:
            return 0
        case .page2:
            return 1
        case .page3:
            return 2
        case .page4:
            return 3
        }
    }
    
    /// Fetches the next page, if it's not the last page
    var nextPage: Page {
        let index = Int(self.index) + 1
        if index < 4 {
            return Page.allCases[index]
        }
        return self
    }
    
    /// Feteches the previous page, it it's not the first one
    var previousPage: Page {
        let index = Int(self.index) - 1
        if index >= 0 {
            return Page.allCases[index]
        }
        return self
    }
    
}
