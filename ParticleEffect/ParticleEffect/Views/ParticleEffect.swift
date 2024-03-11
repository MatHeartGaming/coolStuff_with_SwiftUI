//
//  ParticleEffect.swift
//  ParticleEffect
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

extension View {
    
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inactiveTint: Color) -> some View {
        self
            .modifier(ParticleModifier(systemImage: systemImage, 
                                       font: font,
                                       status: status,
                                       activeTint: activeTint,
                                       inactiveTint: inactiveTint)
            )
    }
    
}


fileprivate struct ParticleModifier: ViewModifier {
    
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inactiveTint: Color
    
    /// View properties
    @State private var particles = [Particle]()
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles) { particle in
                        Image(systemName: systemImage)
                            .foregroundStyle(status ? activeTint : inactiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            /// Only visible when status is active
                            .opacity(status ? 1 : 0)
                            /// Base Visibility with zero animation
                            .animation(.none, value: status)
                    } //: LOOP
                } //: ZSTACK
                .onAppear {
                    // Adding base particles for animation
                    if particles.isEmpty {
                        // Change to fit your needs
                        // particles =  Array(repeating: Particle(), count: 15)
                        for _ in 0...15 {
                            particles.append(Particle())
                        }
                    }
                }
                .onChange(of: status) { oldValue, newValue in
                    if !newValue {
                        // Reset animation
                        resetParticles()
                    } else {
                        // Run animation
                        runAnimation()
                    }
                }
            }
    }
    
    //MARK: - FUNCTIONS
    
    func runAnimation() {
        for index in particles.indices {
            /// Random Z & Y calculation based on index
            let total: CGFloat = CGFloat(particles.count)
            let progress: CGFloat = CGFloat(index) / total
            
            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
            let maxY: CGFloat = 60
            
            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
            
            let randomScale: CGFloat = .random(in: 0.35...1)
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                /// Extra random values for spreading particles
                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                let extraRandomY: CGFloat = .random(in: 0...30)
                
                particles[index].randomX = randomX + extraRandomX
                particles[index].randomY = -randomY - extraRandomY
            }
            
            withAnimation(.easeIn(duration: 0.3)) {
                particles[index].scale = randomScale
            }
            
            // Removing particles
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + Double(index) * 0.0005)) {
                particles[index].scale = 0.001
            }
        }
    }
    
    func resetParticles() {
        for index in particles.indices {
            particles[index].reset()
        }
    }
    
}

#Preview(body: {
    ContentView()
})
