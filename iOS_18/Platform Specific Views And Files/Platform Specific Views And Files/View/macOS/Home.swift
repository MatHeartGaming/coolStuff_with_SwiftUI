//
//  Home.swift
//  Platform Specific Views And Files
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

#if os(macOS)
struct Home: View {
    var body: some View {
        Text("macOS Home")
    }
}

#Preview {
    Home()
}
#endif
