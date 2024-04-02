//
//  ContentView.swift
//  Instagram Pinch to Zoom
//
//  Created by Matteo Buompastore on 02/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZoomContainer {
            TabView {
                NavigationStack {
                    ScrollView(.vertical) {
                        VStack(spacing: 15) {
                            ForEach(posts) { post in
                                CardView(post)
                            } //: Posts Loop
                        } //: VSTACK
                        .padding(15)
                    } //: SCROLL
                    .navigationTitle("Instagram Pinch to Zoom")
                } //: NAVIGATION
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                
                Text("Profile")
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
            } //: TABVIEW
        }
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func CardView(_ post: Post) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader {
                let size = $0.size
                Image(post.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 10))
                    .pinchZoom()
                
            } //: GEOMETRY
            .frame(height: 240)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.title)
                        .font(.callout)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("By \(post.author)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                } //: VSTACK
                
                Spacer(minLength: 0)
                
                if let link = URL(string: post.url) {
                    Link("Visit", destination: link)
                        .font(.caption)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                }
            } //: HSTACK
            .padding(.horizontal, 10)
        } //: VSTACK
    }
    
}

#Preview {
    ContentView()
}
