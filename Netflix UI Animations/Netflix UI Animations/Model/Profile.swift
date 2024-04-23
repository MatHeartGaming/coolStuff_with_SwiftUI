//
//  Profile.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 23/04/24.
//

import SwiftUI

struct Profile: Identifiable {
    
    let id = UUID()
    var name: String
    var icon: String
    
    var sourceAnchorID: String {
        return id.uuidString + "SOURCE"
    }
    
    var destinationAnchorID: String {
        return id.uuidString + "DESTINATION"
    }
    
}

var mockProfiles: [Profile] = [
    .init(name: "Leon S. Kennedy", icon: "Leon"),
    .init(name: "MatBuompy", icon: "Mat")
]
