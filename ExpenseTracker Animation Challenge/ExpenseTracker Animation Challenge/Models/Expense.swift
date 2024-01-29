//
//  Expense.swift
//  ExpenseTracker Animation Challenge
//
//  Created by Matteo Buompastore on 29/01/24.
//

import SwiftUI

struct Expense: Identifiable {
 
    let id = UUID().uuidString
    var icon: String
    var title: String
    var subtitle: String
    var amount: String

}

var expenses: [Expense] = [
    .init(icon: "Food", title: "Food", subtitle: "A Food Restaurant", amount: "€190,00"),
    .init(icon: "Netflix", title: "Netflix", subtitle: "Monthly Subscription", amount: "€5,50"),
    .init(icon: "Taxi", title: "Taxi", subtitle: "\(Bool.random() ? "Fake Taxi" : "Crazy Taxi")", amount: "€20,00"),
]

let months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
let progressArray = CGFloat.random(in: 0.1...1)
