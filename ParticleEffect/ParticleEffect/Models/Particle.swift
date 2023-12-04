//
//  Particle.swift
//  ParticleEffect
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct Particle: Identifiable {
    
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
    
    
}
