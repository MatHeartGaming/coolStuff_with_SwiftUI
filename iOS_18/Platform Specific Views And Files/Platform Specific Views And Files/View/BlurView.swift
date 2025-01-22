//
//  BlurView.swift
//  Platform Specific Views And Files
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

#if os(iOS)
struct BlurView: View {
    var body: some View {
        Text("iOS View")
    }
}
#else
struct BlurView: View {
    var body: some View {
        Text("macOS View")
    }
}
#endif

#Preview {
    BlurView()
}
