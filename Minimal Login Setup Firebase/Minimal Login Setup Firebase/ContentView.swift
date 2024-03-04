//
//  ContentView.swift
//  Minimal Login Setup Firebase
//
//  Created by Matteo Buompastore on 04/03/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    //MARK: - Properties
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if logStatus {
            Home()
        } else {
            Login()
        }
    }
}

#Preview {
    ContentView()
}
