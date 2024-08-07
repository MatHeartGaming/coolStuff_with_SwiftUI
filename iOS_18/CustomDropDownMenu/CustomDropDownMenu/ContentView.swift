//
//  ContentView.swift
//  CustomDropDownMenu
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

var pickerValues: [String] = ["YouTube", "Facebook", "Instagram", "X (Twitter)", "TikTok", "Snapchat"]

struct ContentView: View {
    
    // MARK: Properties
    @State private var config: DropDownConfig = .init(activeText: "YouTube")
    
    var body: some View {
        NavigationStack {
            List {
                SourceDropDownView(config: $config)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            } //: List
            .navigationTitle("DropDown")
        } //: NAVIGATION
        /// If the DropDown View is inside modals (sheet) use this modifier in root of the modal
        .dropDownOverlay($config, values: pickerValues)
    }
}

#Preview {
    ContentView()
}
