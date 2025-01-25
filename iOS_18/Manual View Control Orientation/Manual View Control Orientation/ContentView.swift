//
//  ContentView.swift
//  Manual View Control Orientation
//
//  Created by Matteo Buompastore on 25/01/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var orientation: Orientation = .portrait
    @State private var showFullScreenCover: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Orientation") {
                    
                    Picker("", selection: $orientation) {
                        ForEach(Orientation.allCases, id: \.rawValue) { orientation in
                            Text(orientation.rawValue)
                                .tag(orientation)
                        } //: Loop Orientations
                    } //: Picker
                    .pickerStyle(.segmented)
                    .onChange(of: orientation, initial: true) { oldValue, newValue in
                        modifyOrientation(newValue.mask)
                    }
                    
                } //: Section Orientation
                
                Section("Actions") {
                    NavigationLink("Detail View") {
                        DetailView(userSelection: orientation)
                    } //: Nav Link
                } //: Section Action
                
                Section("Show Full Screen Cover") {
                    
                    Button("Show Full Screen Cover") {
                        modifyOrientation(.landscapeRight)
                        
                        /// To retain animation when opening the Full Screen Cover
                        DispatchQueue.main.async {
                            showFullScreenCover.toggle()
                        }
                    }
                    
                } //: Section Full Screen Cover
                
            } //: LIST
            .navigationTitle("Manual Orientation")
            .fullScreenCover(isPresented: $showFullScreenCover) {
                Rectangle()
                    .fill(.red.gradient)
                    .overlay {
                        Text("Hello From Full Screen Cover!")
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        Button("Close") {
                            modifyOrientation(orientation.mask)
                            showFullScreenCover.toggle()
                        }
                        .padding(15)
                    }
            }
        } //: NAVIGATION
    }
}

struct DetailView: View {
    
    var userSelection: Orientation
    @Environment(\.dismiss) private var dismiss
    @State private var hasRotated: Bool = false
    
    var body: some View {
        NavigationLink("Sub-Detail View") {
            Text("Hi from Sub-Detail View!!")
                .onAppear {
                    modifyOrientation(.portrait)
                }
                .onDisappear {
                    modifyOrientation(.landscapeLeft)
                }
        }
        .onAppear {
            guard !hasRotated else { return }
            modifyOrientation(.landscapeLeft)
            hasRotated = true
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                    modifyOrientation(userSelection.mask)
                    DispatchQueue.main.async {
                        dismiss()
                    }
                }
            }
        }
    }
    
}

// MARK: Previews
#Preview {
    ContentView()
}
