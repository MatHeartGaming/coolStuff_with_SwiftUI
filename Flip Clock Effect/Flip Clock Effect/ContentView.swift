//
//  ContentView.swift
//  Flip Clock Effect
//
//  Created by Matteo Buompastore on 29/05/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var timer: CGFloat = 0
    @State private var count: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    FlipClockTextEffect(
                        value: .constant(count / 10),
                        size: CGSize(
                            width: 100,
                            height: 150
                        ),
                        fontSize: 70,
                        cornerRadius: 10,
                        foreground: .white,
                        background: .red
                    )
                    
                    FlipClockTextEffect(
                        value: .constant(count % 10),
                        size: CGSize(
                            width: 100,
                            height: 150
                        ),
                        fontSize: 70,
                        cornerRadius: 10,
                        foreground: .white,
                        background: .red
                    )
                    
                } //: HSTACK
                
                
                /*Button("Update") {
                    count += 1
                }
                .padding(.top, 45)*/
                
            } //: VSTACK
            .onReceive(Timer.publish(every: 0.01, on: .current, in: .common).autoconnect(), perform: { _ in
                timer += 0.01
                if timer >= 60 {
                    timer = 0
                }
                count = Int(timer)
            })
            
            
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
