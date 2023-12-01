//
//  PreviewData.swift
//  ExpanseTrackerComplexScroll
//
//  Created by Matteo Buompastore on 01/12/23.
//

import Foundation

var expenses: [Expense] = [
    Expense (amountSpent: "$128", product: "Amazon Purchase", spendType: "Groceries"),
    Expense (amountSpent: "$10", product: "Youtube Premium", spendType: "Streaming"),
    Expense (amountSpent: "$10", product: "Dribbble", spendType: "Membership"),
    Expense (amountSpent: "$99", product: "Magic Keyboard", spendType: "Products"),
    Expense (amountSpent: "S9", product: "Patreon", spendType: "Membership"),
    Expense (amountSpent: "$100", product: "Instagram", spendType: "Ad Publish"),
    Expense (amountSpent: "$15", product: "Netflix", spendType: "Streaming"),
    Expense (amountSpent: "$348", product: "Photoshop", spendType: "Editing"),
    Expense (amountSpent: "$99", product: "Figma", spendType: "Pro Member"),
    Expense (amountSpent: "S89", product: "Magic Mouse", spendType: "Products"),
    Expense (amountSpent: "$1200", product: "Studio Display", spendType: "Products"),
    Expense (amountSpent: "$39", product: "Sketch Subscription", spendType: "Membership")
]

var cards: [Card] = [
    Card (bgColor: .red, balance: "$125.000"),
    Card (bgColor: .blue, balance: "$25.000"),
    Card(bgColor: .darkOrange, balance: "$25.000"),
    Card (bgColor: .purple, balance: "$5.000")
]
