//
//  ContentView.swift
//  TelegramDarkModeAnimation
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @State private var activeTab: Int = 0
    /// Toggle between Dark and Light mode
    @State private var toggles: [Bool] = Array(repeating: false, count: 10)
    
    /// Interface Style
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    @State private var buttonRect: CGRect = .zero
    
    /// Current and previous State Images
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    @State private var maskingAnimation = false
    
    var body: some View {
        /// Sample View
        TabView(selection: $activeTab) {
            NavigationStack {
                List {
                    Section("Text Section") {
                        Toggle("Large Display", isOn: $toggles[0])
                        Toggle("Bold Text", isOn: $toggles[1])
                            .bold()
                    }
                    
                    Section {
                        Toggle("Night Light", isOn: $toggles[2])
                        Toggle("True Tone", isOn: $toggles[3])
                    } header: {
                        Text("Display Section")
                    } footer: {
                        Text("This is a Sample Footer")
                    }
                    
                } //: LIST
                .navigationTitle("Dark Mode")
            } //: NAVIGATION
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        } //: TABVIEW
        .createImage(
            toggleDarkMode: toggleDarkMode,
            currentImage: $currentImage,
            previousImage: $previousImage,
            activateDarkMode: $activateDarkMode
        )
        .overlay{
            GeometryReader {
                let size = $0.size
                if let previousImage, let currentImage {
                    ZStack {
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading) {
                                Circle()
                                    .frame(width: buttonRect.width * (maskingAnimation ? 80 : 1), height: buttonRect.height * (maskingAnimation ? 80 : 1), alignment: .bottomLeading)
                                    .frame(width: buttonRect.width, height: buttonRect.height)
                                    .offset(x: buttonRect.minX, y: buttonRect.minY)
                                    .ignoresSafeArea()
                            }
                    } //: ZSTACK
                    .task {
                        guard !maskingAnimation else { return }
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete) {
                            maskingAnimation = true
                        } completion: {
                            // Removing all snapshots
                            self.currentImage = nil
                            self.previousImage = nil
                            maskingAnimation = false
                        }
                    }
                }
            } //: GEOMETRY
            // Reverse masking to hide dimmed preview
            .mask{
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .frame(width: buttonRect.width, height: buttonRect.height)
                            .offset(x: buttonRect.minX, y: buttonRect.minY)
                            .blendMode(.destinationOut)
                    }
            }
            .ignoresSafeArea()
        } //: OVERLAY SNAPSHOTS
        .overlay(alignment: .topTrailing) {
            Button(action: {
                toggleDarkMode.toggle()
            }, label: {
                Image(systemName: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.title)
                    .foregroundStyle(.primary)
                    .symbolEffect(.bounce, value: toggleDarkMode)
                    .frame(width: 40, height: 40)
            }) //: Button Dark / Light mode
            .rect { rect in
                buttonRect = rect
            }
            .padding(10)
            .disabled(currentImage != nil || previousImage != nil || maskingAnimation)
        } //: BUTTON OVERLAY
        .preferredColorScheme(activateDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
