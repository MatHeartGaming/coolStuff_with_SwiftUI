//
//  HeroLayer.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

struct HeroLayer: View {
    
    //MARK: - Properties
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    HeroLayer()
        .environment(UICoordinator())
}
