//
//  ContentView.swift
//  Animated OTP TextField
//
//  Created by Matteo Buompastore on 30/01/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var code: String = ""
    
    var body: some View {
        VerificationField(type: .six, style: .roundedBorder, value: $code) { result in
            
            if result.count < 6 {
                return .typing
            } else if result == "123456" {
                return .valid
            } else {
                return .invalid
            }
            
        }
    }
}

#Preview {
    ContentView()
}
