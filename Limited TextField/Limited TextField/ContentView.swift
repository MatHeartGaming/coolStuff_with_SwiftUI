//
//  ContentView.swift
//  Limited TextField
//
//  Created by Matteo Buompastore on 02/04/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                LimitedTextfield(
                    config: .init(
                        limit: 40,
                        tint: .secondary,
                        autoResizes: true,
                        allowsExcessTyping: false
                    ),
                    hint: "Type here",
                    value: $text
                )
                .autocorrectionDisabled()
                .frame(maxHeight: 150)
            } //: VSTACK
            .padding()
            .navigationTitle("Limited Textfield")
        }
    }
}

#Preview {
    ContentView()
}
