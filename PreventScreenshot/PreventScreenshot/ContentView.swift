//
//  ContentView.swift
//  PreventScreenshot
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var hideScreen = false
    
    var body: some View {
        NavigationStack {
            
            List {
                
                NavigationLink {
                    ScreenshotPreventView {
                        GeometryReader {
                            let size = $0.size
                            
                            Image(.pic)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(topLeadingRadius: 55, bottomTrailingRadius: 55))
                        }
                        .padding(15)
                    }
                    .navigationTitle("MatBuompy")
                } label: {
                    Text("Show Image")
                } //: NAV LINK 1
                
                NavigationLink {
                    List {
                        Section("API Keys") {
                            ScreenshotPreventView {
                                Text("sdfkndjkksn9374834j")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        Section("Netflix Password") {
                            ScreenshotPreventView {
                                Text("Password potente")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .navigationTitle("Keys")
                } label: {
                    Text("Show Security Keys")
                } //: NAV LINK 1
                
            } //: LIST
            .navigationTitle("My List")
            
        } //: NAVIGATION
        .hideView(hideScreen)
        .onChange(of: scenePhase) { oldValue, newValue in
            switch(newValue) {
                
            case .background, .inactive:
                hideScreen = true
            case .active:
                hideScreen = false
            @unknown default:
                hideScreen = false
            }
        }
    }
    
}

extension View {
    
    func hideView<Content: View>(_ hide: Bool, @ViewBuilder with view: @escaping () -> Content = { Color.white }) -> some View {
        ZStack {
            self
            
            if hide {
                view()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
