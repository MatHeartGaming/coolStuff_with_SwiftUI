//
//  ContentView.swift
//  Hacker Text Effect
//
//  Created by Matteo Buompastore on 20/05/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var trigger: Bool = false
    @State private var text = "Hello World"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HackerTextView(
                text: text,
                trigger: trigger,
                transition: .numericText(countsDown: trigger),
                speed: 0.1
            )
                .font(.largeTitle.bold())
                .lineLimit(2)
            
            Button(action: {
                text = ["Made with SwiftUI by\nMatBuompy", "Hello World", "This is an Hacker\nText View."].randomElement()!
                trigger.toggle()
            }, label: {
                Text("Trigger")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 2)
            }) //: Button Trigger
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
            
        } //: VSTACK
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
