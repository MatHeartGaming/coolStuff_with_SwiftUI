//
//  Home.swift
//  Minimal Login Setup Firebase
//
//  Created by Matteo Buompastore on 04/03/24.
//

import SwiftUI
import Firebase

struct Home: View {
    
    //MARK: - Properties
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            Button("Logout") {
                try? Auth.auth().signOut()
                logStatus = false
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    Home()
}
