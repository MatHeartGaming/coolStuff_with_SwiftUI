//
//  ContentView.swift
//  AppThemeSwitcher
//
//  Created by Matteo Buompastore on 27/12/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - UI
    @Environment(\.colorScheme) private var scheme
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Button("Change Theme") {
                        changeTheme.toggle()
                    }
                } //: SECTION
            } //: LIST
            .navigationTitle("Settings")
        } //: NAVIGATION
        .preferredColorScheme(userTheme.colorScheme)
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangerView(scheme: scheme)
            /// Since max height is 410
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
}

#Preview {
    ContentView()
}
