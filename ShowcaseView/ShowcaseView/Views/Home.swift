//
//  Home.swift
//  ShowcaseView
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI
import MapKit

struct Home: View {
    
    // MARK: - UI
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
        latitudinalMeters: 1000, longitudinalMeters: 1000)
    
    var body: some View {
        TabView {
            GeometryReader { geometry in
                let safeArea = geometry.safeAreaInsets
                
                Map(bounds: MapCameraBounds())
                /// Top safe area material view
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: safeArea.top)
                    } //: MAP
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        VStack {
                            Button(action: {}, label: {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.black)
                                    )
                            }) //: BUTTON LOCATION
                            .showCase(order: 0, 
                                      title: "My Current Location",
                                      cornerRadius: 10,
                                      style: .continuous
                            )
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {}, label: {
                                Image(systemName: "suit.heart.fill")
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.red)
                                    )
                            }) //: BUTTON HEART
                            .showCase(order: 1,
                                      title: "Favourite Location",
                                      cornerRadius: 10,
                                      style: .continuous
                            )
                            
                        } //: VSTACK
                        .padding(15)
                    } //: MAP OVERLAY
                
            } //: GEOMETRY
            .tabItem {
                Image(systemName: "macbook.and.iphone")
                Text("Devices")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            
            Text("")
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Items")
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Me")
                }
        } //: TABVIEW
        /// To also be able to Highlight Tab items
        .overlay(alignment: .bottom, content: {
            HStack(spacing: 0) {
                Circle()
                    .foregroundStyle(.clear)
                    .frame(width: 45, height: 45)
                    .showCase(order: 2,
                              title: "My Devices",
                              cornerRadius: 20,
                              style: .continuous,
                              scale: 1.2
                    )
                    .frame(maxWidth: .infinity)
                
                Circle()
                    .foregroundStyle(.clear)
                    .frame(width: 45, height: 45)
                    .showCase(order: 3,
                              title: "Location enabled tags",
                              cornerRadius: 20,
                              style: .continuous,
                              scale: 1.2
                    )
                    .frame(maxWidth: .infinity)
                
                Circle()
                    .foregroundStyle(.clear)
                    .frame(width: 45, height: 45)
                    .showCase(order: 4,
                              title: "Personal Infos",
                              cornerRadius: 20,
                              style: .continuous,
                              scale: 1.2
                    )
                    .frame(maxWidth: .infinity)
            } //: HSTACK
            /// Disabling user interactions
            .allowsHitTesting(false)
        })
        /// Call this modifier on the top of the current view
        .modifier(ShowcaseRoot(showHighlights: true, onFinished: {
            print("Finished onboarding")
        }))
    }
}

#Preview {
    Home()
}
