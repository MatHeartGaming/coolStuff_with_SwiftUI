//
//  ContentView.swift
//  Interactive SideMenu
//
//  Created by Matteo Buompastore on 26/03/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var showMenu = false
    
    var body: some View {
        AnimatedSideBar(
            rotatesWhenExapnds: true,
            disablesInteraction: true,
            sideMenuWidth: 200,
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack {
                List {
                    NavigationLink("Detail View") {
                        Text("Hi Leon!")
                            .navigationTitle("Detail")
                    }
                } //: LIST
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showMenu.toggle()
                        }, label: {
                            Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                                .foregroundStyle(Color.primary)
                                .contentTransition(.symbolEffect)
                        })
                    }
                } //: Toolbar
            } //: NAVIGATION
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } background: {
            Rectangle()
                .fill(.sideMenu)
        }
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Side Menu")
                .font(.largeTitle.bold())
            
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                if tab == Tab.logout {
                    Spacer(minLength: 0)
                }
                SideBarButton(tab)
            }
        } //: VSTACK
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .environment(\.colorScheme, .dark)
    }
    
    @ViewBuilder
    private func SideBarButton(_ tab: Tab, onTap: @escaping () -> Void = {  }) -> some View {
        Button(action: onTap , label: {
            HStack(spacing: 12) {
                Image(systemName: tab.rawValue)
                    .font(.title3)
                
                Text(tab.title)
                    .font(.callout)
                
                Spacer(minLength: 0)
            } //: HSTACK
            .padding(.vertical, 10)
            .contentShape(.rect)
            .foregroundStyle(Color.primary)
        })
    }
    
    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case bookmark = "book.fill"
        case favourites = "heart.fill"
        case profile = "person.crop.circle"
        case logout = "rectangle.portrait.and.arrow.right.fill"
        
        var title: String {
            switch self {
            case .home:
                return "Home"
            case .bookmark:
                return "Bookmarks"
            case .favourites:
                return "Favourites"
            case .profile:
                return "Profile"
            case .logout:
                return "Logout"
            }
        }
        
    }
    
}

#Preview {
    ContentView()
}
