//
//  ContentView.swift
//  MacOS Dock Progress Bar
//
//  Created by Matteo Buompastore on 23/01/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @StateObject private var dockProgress = DockProgress.shared
    
    var body: some View {
        VStack(spacing: 50) {
            Picker("Style", selection: $dockProgress.type) {
                ForEach(DockProgress.ProgressType.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            } //: PICKER Type
            .pickerStyle(.segmented)
            
            Toggle("Show Dock Progress", isOn: $dockProgress.isVisible)
                .toggleStyle(.switch)
            
        } //: VSTACK
        .padding(15)
        .frame(width: 200, height: 200)
        /// Used to update the the animation progress
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            if dockProgress.isVisible {
                dockProgress.progress += 0.007
                
                if dockProgress.progress >= 1 {
                    dockProgress.isVisible = false
                    dockProgress.progress = 0
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
