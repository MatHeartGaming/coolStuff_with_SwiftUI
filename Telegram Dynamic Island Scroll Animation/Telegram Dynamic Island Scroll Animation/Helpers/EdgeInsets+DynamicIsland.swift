//
//  EdgeInsets+DynamicIsland.swift
//  Telegram Dynamic Island Scroll Animation
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

extension EdgeInsets {
    
    func hasDynamicIsland() -> Bool {
        return self.top > 51
    }
    
    func hasNotch() -> Bool {
        self.bottom != .zero
    }
    
}
