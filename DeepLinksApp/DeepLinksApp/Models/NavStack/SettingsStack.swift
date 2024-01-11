//
//  SettingsStack.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

enum SettingsStack: String, CaseIterable {
    
    case myProfile = "My Profile"
    case dataUsage = "Data Usage"
    case privacyPolicy = "Privacy Policy"
    case termsOfService = "Terms of service"
    
    static func convert(from: String) -> Self? {
        return self.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased ()
        }
    }
}
