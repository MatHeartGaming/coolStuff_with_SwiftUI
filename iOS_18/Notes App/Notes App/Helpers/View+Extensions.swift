//
//  View+Extensions.swift
//  Notes App
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI

extension View {
    var noteAnimation: Animation {
        .smooth(duration: 0.3, extraBounce: 0)
    }
}
