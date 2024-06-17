//
//  NewSymbolEffects.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

struct NewSymbolEffects: View {
    
    @State private var trigger = false
    
    var body: some View {
        Image(systemName: "gearshape")
            .font(.system(size: 100))
            .symbolEffect(.breathe, value: trigger)
            .onTapGesture {
                trigger.toggle()
            }
    }
    
}

#Preview {
    NewSymbolEffects()
}
