//
//  PaymentStatus.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

enum PaymentStatus: String, CaseIterable {
    case started = "Connected..."
    case initiated = "Secure payment..."
    case finished = "Purchased"
    
    var symbolImage: String {
        switch self {
        case .started:
            return "wifi"
        case .initiated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
