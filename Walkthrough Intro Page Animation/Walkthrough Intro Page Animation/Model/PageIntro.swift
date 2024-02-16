//
//  PageIntro.swift
//  Walkthrough Intro Page Animation
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI

struct PageIntro: Identifiable, Hashable {
    let id = UUID()
    var introAssetImage: String
    var title: String
    var subtitle: String
    var displaysAction: Bool = false
}


var pageIntros: [PageIntro] = [
    .init(introAssetImage: "Page 1", title: "Connect With\nCreators Easily", subtitle: "Thank you for choosing us, we can save your lovely time."),
    .init(introAssetImage: "Page 2", title: "Get Inspiration\nFrom Creators", subtitle: "Find your favourite creator and get inspired by them."),
    .init(introAssetImage: "Page 3", title: "Let's\nGet Started", subtitle: "To register for an account, kindly enter your details.", displaysAction: true),
]
