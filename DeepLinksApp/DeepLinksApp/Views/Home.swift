//
//  Home.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        TabView(selection: $appData.activeTab) {
            
            HomeView()
                .tag(Tab.home)
                .tabItem {
                    Image(systemName: Tab.home.symbolImage)
                }
            
            FavoriteView()
                .tag(Tab.favourite)
                .tabItem {
                    Image(systemName: Tab.favourite.symbolImage)
                }
            
            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Image(systemName: Tab.settings.symbolImage)
                }
            
        } //: TABVIEW
        .tint(.red)
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    func HomeView() -> some View {
        NavigationStack(path: $appData.homeNavStack) {
            
            List {
                ForEach(HomeStack.allCases, id: \.rawValue) { link in
                    
                    NavigationLink(value: link) {
                        Text(link.rawValue)
                    }
                    
                } //: LOOP
            } //: LIST
            .navigationTitle("Home")
            .navigationDestination(for: HomeStack.self) { link in
                /// Generally you use a switch here... But for the sake of mainteining this short I'll stick to  a Text
                Text(link.rawValue)
            }
            
        } //: NAVIGATION
    }
    
    @ViewBuilder
    func FavoriteView() -> some View {
        NavigationStack(path: $appData.favoriteNavStack) {
            
            List {
                ForEach(FavoriteStack.allCases, id: \.rawValue) { link in
                    
                    NavigationLink(value: link) {
                        Text(link.rawValue)
                    }
                    
                } //: LOOP
            } //: LIST
            .navigationTitle("Favorites")
            .navigationDestination(for: FavoriteStack.self) { link in
                /// Generally you use a switch here... But for the sake of mainteining this short I'll stick to  a Text
                Text(link.rawValue)
            }
            
        } //: NAVIGATION
    }
    
    @ViewBuilder
    func SettingsView() -> some View {
        NavigationStack(path: $appData.settingsNavStack) {
            
            List {
                ForEach(SettingsStack.allCases, id: \.rawValue) { link in
                    
                    NavigationLink(value: link) {
                        Text(link.rawValue)
                    }
                    
                } //: LOOP
            } //: LIST
            .navigationTitle("Settings")
            .navigationDestination(for: SettingsStack.self) { link in
                /// Generally you use a switch here... But for the sake of mainteining this short I'll stick to  a Text
                Text(link.rawValue)
            }
            
        } //: NAVIGATION
    }
    
}

#Preview {
    Home()
        .environmentObject(AppData())
}
