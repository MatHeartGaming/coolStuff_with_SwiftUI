//
//  Home.swift
//  Platform Specific Views And Files
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

#if os(iOS)
struct Home: View {
    var body: some View {
        Text("iOS Home")
    }
}

#Preview {
    Home()
}
#endif
