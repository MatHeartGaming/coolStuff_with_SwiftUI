//
//  SharedManager.swift
//  ControlCenterAPI
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

class SharedManager {
    static let shared = SharedManager()
    var isTurnedOn: Bool = false
    
    ///Control Button
    var caffeineIntake: CGFloat = 0
}
