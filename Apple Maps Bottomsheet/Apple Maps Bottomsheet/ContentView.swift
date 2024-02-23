//
//  ContentView.swift
//  Apple Maps Bottomsheet
//
//  Created by Matteo Buompastore on 23/02/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    //MARK: - Properties
    @State private var showSheet: Bool = false
    @State private var activeTab: Tab = .devices
    @State private var ignoretabBar: Bool = false
    
    var body: some View {
        TabView {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .tag(tab)
                    .tabItem {
                        Image(systemName: tab.symbol)
                        Text(tab.rawValue)
                    }
                    .toolbarBackground(.visible, for: .tabBar)
            } //: Loop Tabs
        } //: TABVIEW
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet, content: {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(activeTab.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Toggle("Ignore Tab Bar", isOn: $ignoretabBar)
                } //: VSTACK
                .padding()
            } //: V-SCROLL
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(60), .medium, .large])
            .presentationCornerRadius(20)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            /// Add mask inside sheet View
            .bottomMaskForSheet(mask: !ignoretabBar)
        })
    }
}

struct CustomTabBarVersion: View {
    
    //MARK: - Properties
    @State private var showSheet: Bool = false
    @State private var activeTab: Tab = .devices
    @State private var ignoretabBar: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 17, *) {
                Map(initialPosition: .region(.applePark))
            } else {
                Map(coordinateRegion: .constant(.applePark))
            }
            
            /// Tab Bar
            TabBar()
                .frame(height: 49)
                .background(.regularMaterial)
            
        } //: ZSTACK
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet, content: {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(activeTab.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Toggle("Ignore Tab Bar", isOn: $ignoretabBar)
                } //: VSTACK
                .padding()
            } //: V-SCROLL
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(60), .medium, .large])
            .presentationCornerRadius(20)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            /// Add mask inside sheet View
            .bottomMaskForSheet(mask: !ignoretabBar)
        })
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    withAnimation(.snappy(duration: 0.2)) {
                        activeTab = tab
                    }
                }, label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.symbol)
                            .font(.title2)
                        Text(tab.rawValue)
                            .font(.caption)
                    } //: VSTACK
                    .foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                }) //: Tab Button
                .buttonStyle(.plain)
            } //: Loop Tabs
        } //: HSTACK
    }
    
}

extension MKCoordinateRegion {
    static var applePark: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: 37.334606, longitude: -122.009102)
        return .init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

#Preview {
    ContentView()
}

#Preview {
    CustomTabBarVersion()
}
