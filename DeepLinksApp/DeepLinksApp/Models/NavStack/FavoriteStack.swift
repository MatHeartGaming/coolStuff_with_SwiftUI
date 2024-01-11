//
//  FavoriteStack.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

enum FavoriteStack: String, CaseIterable {
    
    case residentEvil = "Resident Evil"
    case stray = "Stray"
    case medievil = "Medievil"
    
    static func convert(from: String) -> Self? {
        return self.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased ()
        }
    }
}

