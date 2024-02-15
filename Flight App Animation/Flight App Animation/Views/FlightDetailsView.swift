//
//  FlightDetailsView.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

struct FlightDetailsView: View {
    // MARK: - Properties
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    var body: some View {
        VStack(alignment: alignment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundStyle(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FlightDetailsView(place: "Napoli", code: "NAC", timing: "24 Jul, 11:00")
}
