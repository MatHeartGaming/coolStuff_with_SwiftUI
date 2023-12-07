//
//  ContentView.swift
//  Auto OTP TextField
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            OTPVerificationView()
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(false)
        }
    }
}

#Preview {
    ContentView()
}
