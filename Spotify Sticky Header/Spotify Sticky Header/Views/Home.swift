//
//  Home.swift
//  Spotify Sticky Header
//
//  Created by Matteo Buompastore on 24/01/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    var safeArea: EdgeInsets
    var size: CGSize
    
    var body: some View {
        ScrollView(.vertical) {
            
            VStack {
                /// Album Pic
                ArtWork()
                
                GeometryReader { proxy in
                    /// Since we ignored top edge
                    let minY = proxy.frame(in: .named("SCROLL")).minY - safeArea.top
                    
                    Button(action: {}, label: {
                        Text("SHUFFLE PLAY")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 45)
                            .padding(.vertical, 12)
                            .background {
                                Capsule()
                                    .fill(.spotifyGreen.gradient)
                            }
                    }) //: BUTTON SHUFFLE PLAY
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: minY < 50 ? -(minY - 50) : 0)
                } //: GEOMETRY
                .frame(height: 50)
                .padding(.top, -34)
                .zIndex(1)
                
                VStack {
                    
                    Text("Popular")
                        .fontWeight(.heavy)
                    
                    /// Album View
                    AlbumView()
                    
                } //: VSTACK
                .padding(.top, 10)
                .zIndex(0)
                
            } //: VSTACK
            .overlay(alignment: .top) {
                HeaderView()
            }
            
        } //: SCROLL
        .scrollIndicators(.hidden)
        .coordinateSpace(name: "SCROLL")
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func ArtWork() -> some View {
        let randomListens = Int.random(in: 5_000_000...30_000_000)
        let height = size.height * 0.45
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            Image(.myloxyloto)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .clipped()
                .overlay {
                    ZStack {
                        
                        /// Gradient Overlay
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    .black.opacity(0 - progress),
                                    .black.opacity(0.1 - progress),
                                    .black.opacity(0.3 - progress),
                                    .black.opacity(0.5 - progress),
                                    .black.opacity(0.8 - progress),
                                    .black.opacity(1),
                                ], startPoint: .top, endPoint: .bottom)
                            )
                        
                        VStack(spacing: 0) {
                            
                            
                            Text("Mylo Xyloto")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text("Coldplay")
                                .font(.callout.bold())
                                .padding(.top, 15)
                            
                            Text("\(randomListens) Monthly Listners")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                //.padding(.top, 15)
                                
                            
                        } //: VSTACK
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        /// Moving with ScrollView
                        .padding(.bottom, 55)
                        .offset(y: minY < 0 ? minY : 0)
                        
                    } //: ZSTACK
                } //: Gradient Overlay
                .offset(y: -minY)
            
        } //: GEOMETRY
        .frame(height: height + safeArea.top)
    }
    
    @ViewBuilder
    private func AlbumView() -> some View {
        VStack(spacing: 25) {
            ForEach(songs.indices, id: \.self) { index in
                HStack(spacing: 25) {
                    
                    let randomListens = Int.random(in: 200_000...2_000_000)
                    
                    Text("\(index + 1)")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(songs[index].songName)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                        Text("\(randomListens)")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                    } //: VSTACK
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.gray)
                }
            } //: LOOP Songs
        } //: VSTACK
        .padding(15)
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress = minY / height
            HStack(spacing: 15) {
                Button(action: {}, label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        /// You could use titleprogress to apply different styles based on the scroll position
                        .foregroundStyle(.white)
                }) //: Back Button
                
                Spacer(minLength: 0)
                
                Button(action: {}, label: {
                    Text("FOLLOWING")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .overlay(
                            Capsule()
                                .stroke(style: .init(lineWidth: 1))
                                .foregroundStyle(.white)
                        )
                }) //: Follow Button
                .opacity(1 + progress)
                
                
                Button(action: {}, label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundStyle(.white)
                }) //: Back Button
            } //: HSTACK
            .overlay {
                Text("Coldplay")
                    .fontWeight(.semibold)
                    /// Choose where to display the title
                    .offset(y: -titleProgress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25),
                               value: -titleProgress > 0.75 ? 0 : 45)
            }
            .padding(.top, safeArea.top + 10)
            .padding([.horizontal, .bottom], 15)
            .background {
                Color.black
                    .opacity(-progress > 1 ? 1 : 0)
            }
            .offset(y: -minY)
            
        } //: GEOMETRY
        .frame(height: 35)
    }
    
}

#Preview {
    GeometryReader { proxy in
        let safeArea = proxy.safeAreaInsets
        let size = proxy.size
        Home(safeArea: safeArea, size: size)
    }
    .preferredColorScheme(.dark)
}

#Preview {
    ContentView()
}
