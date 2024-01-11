//
//  AppData.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import Foundation

class AppData: ObservableObject {
    
    @Published var activeTab: Tab = .home
    @Published var homeNavStack: [HomeStack] = []
    @Published var favoriteNavStack: [FavoriteStack] = []
    @Published var settingsNavStack: [SettingsStack] = []

}
