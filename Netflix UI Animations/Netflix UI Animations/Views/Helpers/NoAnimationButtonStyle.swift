//
//  NoAnimationButtonStyle.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
