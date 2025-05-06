//
//  ContentView.swift
//  Slide To Confirm
//
//  Created by Matteo Buompastore on 06/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                let config = SlideToConfirm.Config(
                    idleText: "Swipe to Pay",
                    onSwipeText: "Confirm Payment",
                    confirmationText: "Success!",
                    tint: .green,
                    foregroundColor: .white
                )
                
                SlideToConfirm(config: config) {
                    print("Swiped!")
                }
            } //: VSTACK
            .padding(15)
            .navigationBarTitle("Slide To Confirm")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
