//
//  ContentView.swift
//  Disintegration Effect
//
//  Created by Matteo Buompastore on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var isRemoved: Bool = false
    @State private var snapEffect: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if !isRemoved {
                    Group {
                        Image(.pic)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipped()
                            /// Do NOT use on complex Views such as NavigationStacks...
                            .disntegrationEffect(isDeleted: snapEffect) {
                                print("View removed")
                                withAnimation(.snappy) {
                                    isRemoved = true
                                }
                            }
                        
                        Button("Remove View") {
                            snapEffect = true
                        }
                    } //: GROUP
                }
            } //: VSTACK
            .navigationTitle("Disintegration Effect")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
