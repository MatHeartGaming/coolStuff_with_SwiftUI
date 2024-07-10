//
//  Home.swift
//  Draggable Tab Bar
//
//  Created by Matteo Buompastore on 09/07/24.
//

import SwiftUI

struct Home: View {
    
    @Environment(TabProperties.self) private var properties
    
    var body: some View {
        @Bindable var bindings = properties
        NavigationStack {
            List {
                Toggle("Edit Tab Locations", isOn: $bindings.editMode)
            } //: LIST
            .navigationTitle("Home")
        } //: NAVIGATION
    }
}

#Preview {
    Home()
        .environment(TabProperties())
}
