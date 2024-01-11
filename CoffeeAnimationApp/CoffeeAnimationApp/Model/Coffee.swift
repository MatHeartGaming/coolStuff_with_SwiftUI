//
//  Coffee.swift
//  CoffeeAnimationApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

struct Coffee: Identifiable {
    var id: UUID = .init()
    var imageName: String
    var title: String
    var price: String
}
var coffees: [Coffee] = [
    .init(imageName: "Item 1", title: "Caramel\nCold Drink", price: "$3.90"),
    .init(imageName: "Item 2", title: "Caramel\nMacchiato", price: "$2.30"),
    .init(imageName: "Item 3", title: "Iced Coffee\nMocha", price: "$9.20"),
    .init(imageName: "Item 4", title: "Toffee Nut\nCrunch Latte", price: "$12.30"),
    .init(imageName: "Item 5", title: "Styled Cold\nnCoffee", price: "$8.90")
]
