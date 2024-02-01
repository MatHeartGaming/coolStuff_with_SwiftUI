//
//  Crop.swift
//  Photo Editor Cropping Tool
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI

enum Crop: Equatable {
    
    case circle
    case rectangle
    case square
    case custom(CGSize)
    
    func name() -> String {
        switch self {
            
        case .circle:
            "Circle"
        case .rectangle:
            "Rectangle"
        case .square:
            "Square"
        case .custom(let size):
            "Custom \(Int(size.width))x\(Int(size.height))"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle:
            return .init(width: 300, height: 300)
        case .rectangle:
            return .init(width: 300, height: 500)
        case .square:
            return .init(width: 300, height: 300)
        case .custom(let size):
            return size
        }
    }
    
}
