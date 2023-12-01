//
//  ContentView.swift
//  Interactive Pop Gesture
//
//  Created by Matteo Buompastore on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isEnabled = false
    
    var body: some View {
        FullSwipeNavigationStack {
            List {
                Section("Sample Header") {
                    NavigationLink("Full Swipe View") {
                        List {
                            Toggle("Enable Full Swipe Pop", isOn: $isEnabled)
                                .enableFullSwipePop(isEnabled)
                        }
                        .navigationTitle("Full Swipe View")
                    } //: FULL SWIPE
                    
                    NavigationLink("Leading Swipe View") {
                        Text("")
                            .navigationTitle("Leading Swipe View")
                    } //: LEADING SWIPE
                } //: SECTION
            } //: LIST
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
