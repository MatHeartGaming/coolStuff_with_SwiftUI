//
//  SwiftData_Value_TransformersApp.swift
//  SwiftData Value Transformers
//
//  Created by Matteo Buompastore on 24/04/24.
//

import SwiftUI

@main
struct SwiftData_Value_TransformersApp: App {
    
    init() {
        ColorTransformer.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ColorModel.self)
        }
    }
}
