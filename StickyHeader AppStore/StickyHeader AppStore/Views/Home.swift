//
//  Home.swift
//  StickyHeader AppStore
//
//  Created by Matteo Buompastore on 24/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - PROPERTIES
    @State private var time = Timer.publish(every: 0.1, on: .current, in: .tracking)
        .autoconnect()
    @State private var show = false
    
    var body: some View {
        let headerHeight = UIScreen.main.bounds.height / 2.2
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    /// Strecty and Sticky Header
                    
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .named("SCROLL")).minY
                        Image(.poster)
                            .resizable()
                            /// Fixing view to the top
                            .offset(y: minY > 0 ? -minY : 0)
                            .frame(height: minY > 0 ? headerHeight + minY : headerHeight)
                            .clipShape(.rect(cornerRadius: 12, style: .continuous))
                            .onReceive(time, perform: { _ in
                                if -minY > headerHeight - 50 {
                                    show = true
                                } else {
                                    show = false
                                }
                            })
                    } //: GEOMETRY
                    .frame(height: headerHeight)
                    
                    VStack {
                        
                        HStack {
                            Text("New Games We Love")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {}, label: {
                                Text("See All")
                                    .fontWeight(.bold)
                            })
                            
                        } //: HSTACK
                        
                        VStack(spacing: 20) {
                            ForEach(data) { game in
                                CardView(data: game)
                            }
                            
                        } //: VSTACK
                        
                    } //: VSTACK
                    .padding()
                    
                    Spacer()
                } //: VSTACK
            } //: SCROLL
            .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .top)
        }
    }
}

/// Card View
struct CardView: View {
    
    // MARK: - PROPERTIES
    var data: GameCard
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            
            Image(data.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(.rect(cornerRadius: 18, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(data.title)
                    .fontWeight(.bold)
                
                Text(data.subTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    Button(action: {}, label: {
                        Text("GET")
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.primary.opacity(0.06))
                            .clipShape(.capsule)
                    }) //Button GET
                    
                    Text("In-App \nPurchases")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                } //: HSTACK
            } //: VSTACK
            
        } //: HSTACK
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

/// Top View
struct TopView: View {
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                
            }
        }
    }
    
}

#Preview {
    Home()
}

#Preview {
    ContentView()
}
