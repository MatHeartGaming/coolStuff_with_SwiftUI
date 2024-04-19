//
//  AppData.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

@Observable
class AppData {
    var isSplashFinished: Bool = false
    var activeTab: Tab = .home
}
