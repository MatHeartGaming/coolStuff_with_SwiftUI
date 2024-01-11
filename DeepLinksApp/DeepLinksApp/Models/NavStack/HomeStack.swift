//
//  HomeStack.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

enum HomeStack: String, CaseIterable {
    
    case myPosts = "My Posts"
    case oldPosts = "Old Posts"
    case latestPosts = "Latest Posts"
    case deletedPosts = "Deleted Posts"
    
    static func convert(from: String) -> Self? {
        return self.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased ()
        }
    }
}
