//
//  TabModel.swift
//  Apple Mail App Bar
//
//  Created by Matteo Buompastore on 24/01/25.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case primary = "Primary"
    case transactions = "Transactions"
    case update = "Updates"
    case promotions = "Promotions"
    case allMails = "All Mails"
    
    var color: Color {
        switch self {
            case .primary:
                return .blue
            case .transactions:
                return .green
            case .update:
                return .indigo
            case .promotions:
                return .pink
            case .allMails:
                return Color.primary
        }
    }
    
    var symbolImage: String {
        switch self {
            case .primary: "person"
            
            case .transactions: "cart"
                
            case .update: "text.bubble"
                
            case .promotions: "megaphone"
                
            case .allMails: "tray"
        }
    }
}
