//
//  VideoScale.swift
//  MacOS Screen Recording App
//
//  Created by Matteo Buompastore on 23/01/25.
//

import Foundation

enum VideoScale: Int, CaseIterable {
    case normal = 1
    case hight = 2
    
    var stringValue: String {
        switch self {
        case .normal:
            return "1x"
        case .hight:
            return "2x"
        }
    }
}
