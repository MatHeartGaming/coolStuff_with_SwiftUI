//
//  GameCard.swift
//  StickyHeader AppStore
//
//  Created by Matteo Buompastore on 24/01/24.
//

import SwiftUI

struct GameCard: Identifiable {
    let id = UUID()
    var image: String
    var title: String
    var subTitle: String
}

var data: [GameCard] = [
    .init(image: "g1", title: "Angry Birds", subTitle: "Make the pigs fall"),
    .init(image: "g2", title: "Trine 3", subTitle: "The Artifact of Power"),
    .init(image: "g3", title: "Resident Evil Village", subTitle: "Experience Lady Dimistrescu"),
    .init(image: "g4", title: "Temple Run", subTitle: "Run Fast"),
    .init(image: "g5", title: "Heartstone", subTitle: "Play cards"),
    .init(image: "g6", title: "Alto's Adventures", subTitle: "Vola Alto"),
    .init(image: "g7", title: "Lies of P", subTitle: "Pinocchio & Geppetto"),
    .init(image: "g8", title: "Stray", subTitle: "Avoid Zurks and stay with friendly robots with your fancy drone!"),
    .init(image: "g9", title: "Resident Evil 4", subTitle: "The remake we've all been waiting for!")
]
