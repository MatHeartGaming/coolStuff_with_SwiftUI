//
//  Card.swift
//  ExpanseTrackerComplexScroll
//
//  Created by Matteo Buompastore on 01/12/23.
//

import SwiftUI

// Card Model and Sample Cards
struct Card: Identifiable {
    let id: UUID = .init()
    var bgColor: Color
    var balance: String
}
