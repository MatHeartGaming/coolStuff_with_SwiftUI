//
//  Home.swift
//  Spotify Animated Sticky Header
//
//  Created by Matteo Buompastore on 26/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - Properties
    @State private var currentType: String = "Popular"
    @State private var _albums: [Album] = albums
    private let randomListners = Int.random(in: 40_000_000...75_000_000)
    let randomSongListners = Int.random(in: 10_000_000...25_000_000)
    
    @State var headerOffset: (CGFloat, CGFloat) = (0, 0)
    
    /// For smoothing sliding
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                HeaderView()
                
                /// Pinned Header with Content
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        SongList()
                    } header: {
                        PinnedHeaderView()
                            .background(.black)
                            .offset(y: headerOffset.1 > 0 ? 0 : -headerOffset.1 / 8)
                            .modifier(OffsetModifier(
                                offset: $headerOffset.0,
                                returnFromStart: false))
                            .modifier(OffsetModifier(
                                offset: $headerOffset.1))
                        
                    }

                    
                } //: Lazy VSTACK
                
            } //: VSTACK
        } //: SCROLL
        .overlay {
            Rectangle()
                .fill(.black)
                .frame(height: 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(headerOffset.0 < 20 ? 1 : 0)
                .animation(.easeInOut, value: headerOffset.0 < 20)
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            Image(.coldplay)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: height, alignment: .top)
                .clipShape(.rect(cornerRadius: 15))
                .overlay {
                    ZStack {
                        /// Dimming the text content
                        LinearGradient(colors: [.clear, .black.opacity(0.8)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("ARTIST")
                                .font(.callout)
                                .foregroundStyle(.white.opacity(0.7))
                                .shadow(color: .white.opacity(0.8), radius: 10)
                                .shadow(color: .black.opacity(0.8), radius: 4, x: 5, y: 3)
                            
                            HStack(alignment: .bottom, spacing: 10) {
                                
                                Text("Coldplay")
                                    .font(.title.bold())
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.blue)
                                    .background {
                                        Circle()
                                            .fill(.white)
                                            .padding(3)
                                    }
                                
                            } //: HSTACK
                            
                            Label{
                                Text("Monthly Listners")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white.opacity(0.7))
                            } icon: {
                                Text("\(randomListners)")
                                    .fontWeight(.semibold)
                            } //: LABEL LISTENERS
                            .font(.caption)
                            
                            
                        } //: VSTACK
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    } //: ZSTACK
                }
                .offset(y: -minY)
            
        } //: GEOMETRY
        .frame(height: 250)
    }
    
    @ViewBuilder
    private func PinnedHeaderView() -> some View {
        let types = ["Popular", "Albums", "Songs", "Fans also like", "About"]
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing: 25)  {
                
                ForEach(types, id: \.self) { type in
                    
                    VStack(spacing: 12) {
                        
                        Text(type)
                            .fontWeight(.semibold)
                            .foregroundStyle(currentType == type ? .white : .gray)
                        
                        ZStack {
                            /// The if is necessary to make tab switch for some reason...
                            if currentType == type{
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.white)
                                    /// Used for the sliding effect
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        } //: ZSTACK
                        .padding(.horizontal, 8)
                        .frame(height: 4)
                        
                    } //: VSTACK
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentType = type
                        }
                    }
                    
                } //: Loop Types
                
            } //: HSTACK
            .padding(.horizontal)
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 5, trailing: 0))
            
        } //: SCROLL
    }
    
    @ViewBuilder
    private func SongList() -> some View {
        
        VStack(spacing: 25) {
            
            ForEach($_albums) { $album in
                HStack(spacing: 12) {
                    Text("\(getIndex(album) + 1)")
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    
                    Image(album.albumImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .clipShape(.rect(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(album.albumName)
                            .fontWeight(.semibold)
                        
                        Label {
                            Text("\(randomSongListners)")
                        } icon: {
                            Image(systemName: "beats.headphones")
                                .foregroundStyle(.white)
                        }
                        .foregroundStyle(.gray)
                        .font(.caption)
                    } //: VSTACK
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        album.isLiked.toggle()
                    } label: {
                        Image(systemName: album.isLiked ? "suit.heart.filled" : "suit.heart")
                            .font(.title3)
                            .foregroundStyle(album.isLiked ? .spotifyGreen : .white)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }

                    
                } //: HSTACK
            } //: Loop Albums
            
        } //: VSTACK
        .padding()
        .padding(.top, 25)
        .padding(.bottom, 150)
    }
    
    
    //MARK: - Functions
    
    func getIndex(_ album: Album) -> Int {
        return _albums.firstIndex { currentAlbum in
            album.id == currentAlbum.id
        } ?? 0
    }
    
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
