//
//  ContentView.swift
//  App Theme Switcher
//
//  Created by Matteo Buompastore on 28/08/24.
//

import SwiftUI

struct ContentView: View {

    // MARK: Properties
    @AppStorage("AppScheme") private var appScheme: AppScheme = .device
    @SceneStorage("ShowScenePickerView") private var showPickerView: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(1...40, id: \.self) { index in
                    Text("Chat History \(index)")
                } //: Loop
            } //: LIST
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPickerView.toggle()
                    } label: {
                        Image(systemName: "moon.fill")
                            .foregroundStyle(Color.primary)
                    }
                }
            } //: Toolbar
        } //: NAVIGATION
        .animation(.easeInOut(duration: 0.25), value: appScheme)
    }
}

#Preview {
    SchemeHostView {
        ContentView()
    }
}
