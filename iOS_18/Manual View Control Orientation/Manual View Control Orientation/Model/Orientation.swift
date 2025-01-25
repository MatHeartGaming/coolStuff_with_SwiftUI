//
//  Orientation.swift
//  Manual View Control Orientation
//
//  Created by Matteo Buompastore on 25/01/25.
//

import SwiftUI

enum Orientation: String, CaseIterable {
    
    case all = "All"
    case portrait = "Portrait"
    case landscapeLeft = "Left"
    case landscapeRight = "Right"
    
    var mask: UIInterfaceOrientationMask {
        switch self {
        case .all:
            return .all
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        }
    }
    
}
