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
    var hideMainView: Bool = false
    
    /// Profile Selection Properties
    var tabProfileRect: CGRect = .zero
    var showProfileView: Bool = false
    var watchingProfile: Profile?
    var animateProfile: Bool = false
    var fromTabBar: Bool = false
    
}
