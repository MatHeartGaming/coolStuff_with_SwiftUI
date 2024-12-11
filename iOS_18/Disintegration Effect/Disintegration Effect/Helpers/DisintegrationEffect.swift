//
//  DisintegrationEffect.swift
//  Disintegration Effect
//
//  Created by Matteo Buompastore on 11/12/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func disntegrationEffect(isDeleted: Bool, completion: @escaping () -> Void) -> some View {
        self
            .modifier(DisintegrationEffectModifier(isDeleted: isDeleted, completion: completion))
    }
    
}

fileprivate struct DisintegrationEffectModifier: ViewModifier {
    
    var isDeleted: Bool
    var completion: () -> Void
    
    /// UI
    @State private var particles: [SnapParticle] = []
    @State private var animateEffect: Bool = false
    @State private var triggerSnapshot: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(particles.isEmpty ? 1 : 0)
            .overlay(alignment: .topLeading) {
                DisintegrationEffectView(particles: $particles, animateEffect: $animateEffect)
                    .opacity(0.3)
            }
            .snapshot(trigger: triggerSnapshot) { snapshot in
                Task.detached(priority: .high) {
                    try? await Task.sleep(for: .seconds(0.2))
                    await createParticles(snapshot)
                }
            }
            .onChange(of: isDeleted) { oldValue, newValue in
                if newValue && particles.isEmpty {
                    triggerSnapshot = true
                }
            }
    }
    
    private func createParticles(_ snapshot: UIImage) async {
        var particles: [SnapParticle] = []
        let size = snapshot.size
        let width = size.width
        let height = size.height
        /// Avoid exceeding 1600!
        let maxGridCount = 1100
        
        var gridSize: Int = 1
        var rows = Int(height) / gridSize
        var columns = Int(width) / gridSize
        
        while (rows * columns) >= maxGridCount {
            gridSize += 1
            rows = Int(height) / gridSize
            columns = Int(width) / gridSize
        }
        
        for row in 0...rows {
            for column in 0...columns {
                let positionX = column * gridSize
                let positionY = row * gridSize
                
                let cropRect = CGRect(x: positionX, y: positionY, width: gridSize, height: gridSize)
                let croppedImage = cropImage(snapshot, rect: cropRect)
                
                particles.append(.init(
                    particoleImage: croppedImage,
                    particleOffset: .init(width: positionX, height: positionY)))
                
            }
        }
        
        await MainActor.run { [particles] in
            self.particles = particles
            withAnimation(.easeInOut(duration: 1.5), completionCriteria: .logicallyComplete) {
                animateEffect = true
            } completion: {
                completion()
            }
        }
    }
    
    
    private func cropImage(_ snapshot: UIImage, rect: CGRect) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
        return renderer.image { ctx in
            ctx.cgContext.interpolationQuality = .low
            snapshot.draw(at: .init(x: -rect.origin.x, y: -rect.origin.y))
        }
    }
    
}

fileprivate struct DisintegrationEffectView: View {
    
    @Binding var particles: [SnapParticle]
    @Binding var animateEffect: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(particles) { particle in
                Image(uiImage: particle.particoleImage ?? UIImage())
                    .offset(particle.particleOffset)
                    .offset(
                        x: animateEffect ? .random(in: -60...(-10)) : 0,
                        y: animateEffect ? .random(in: -100...(-10)): 0
                    )
                    .opacity(animateEffect ? 0 : 1)
            } //: Loop particles
        } //: ZSTACK
        /// To avoid applying blur to every particle we use compositingGroup
        /// Avoid using fancy modifiers. Recommened: offset, opacity, rotation.
        .compositingGroup()
        .blur(radius: animateEffect ? 5 : 0)
    }
    
}

fileprivate struct SnapParticle: Identifiable {
    
    let id: String = UUID().uuidString
    var particoleImage: UIImage?
    var particleOffset: CGSize
}

#Preview {
    ContentView()
}
