//
//  ContentView.swift
//  Custom3DPicker
//
//  Created by Matteo Buompastore on 10/07/24.
//

import SwiftUI

let pickerValues: [String] = [
    "SwiftUI", "UIKit", "AVKit", "WidgetKit", "LiveActivities"
, "CoreImage", "AppIntents"]

struct ContentView: View {
    
    @State private var config = PickerConfig(text: "SwiftUI")
    
    var body: some View {
        NavigationStack {
            List {
                Section("Configuration") {
                    Button {
                        config.show.toggle()
                        print(config.show)
                    } label: {
                        HStack {
                            Text("Framework")
                                .foregroundStyle(.gray)
                            Spacer(minLength: 0)
                            SourcePickerView(config: $config)
                        }
                    }
                } //: Section
                
            } //: LIST
            .navigationTitle("Custom Picker")
        } //: NAVIGATION
        /// Use this at the root of your app
        .customPicker($config, items: pickerValues)
    }
}

#Preview {
    ContentView()
}
