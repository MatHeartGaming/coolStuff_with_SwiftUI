//
//  Home.swift
//  Complex Hero Animation with Synch ScrollViews
//
//  Created by Matteo Buompastore on 12/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - PROPERTIES
    @State private var posts: [Post] = samplePosts
    
    /// View properties
    @State private var showDetailView = false
    @State private var detailViewAnimation = false
    @State private var selectedPicId: UUID?
    @State private var selectedPost: Post?
    
    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    ForEach(posts) { post in
                        CardView(post)
                    }
                } //: VSTACK
                .safeAreaPadding(15)
            } //: SCROLL
            .navigationTitle("Animation")
            .overlay {
                if showDetailView {
                    DetailView(
                        showDetailView: $showDetailView,
                        detailViewAnimation: $detailViewAnimation,
                        post: selectedPost,
                        selectedPicID: $selectedPicId
                    ) { id in
                        /// Updating scroll position
                        if let index = posts.firstIndex(where: { $0.id == selectedPost?.id }) {
                            posts[index].scrollPosition = id
                        }
                    }
                    .transition(.offset(y: 5))
                }
            } //: OVERLAY DETAILS
            .overlayPreferenceValue(OffsetKey.self, { value in
                GeometryReader { proxy in
                    if let selectedPicId, let source = value[selectedPicId.uuidString],
                       let destination = value["DESTINATION\(selectedPicId.uuidString)"],
                        let picItem = selectedImage(), showDetailView {
                        let sRect = proxy[source]
                        let dRect = proxy[destination]
                        
                        Image(picItem.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: detailViewAnimation ? dRect.width : sRect.width,
                                   height: detailViewAnimation ? dRect.height : sRect.height)
                            .clipShape(.rect(cornerRadius: detailViewAnimation ? 0 : 10))
                            .offset(x: detailViewAnimation ? dRect.minX : sRect.minX,
                                    y: detailViewAnimation ? dRect.minY : sRect.minY)
                            .allowsTightening(false)
                    }
                }
            })
            
        } //: NAVIGATION
    }
    
    
    //MARK: - Functions
    
    private func selectedImage() -> PicItem? {
        if let pic = selectedPost?.pics.first(where: { $0.id == selectedPicId }) {
            return pic
        }
        return nil
    }
    
    //MARK: - Views
    
    @ViewBuilder
    private func CardView(_ post: Post) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.teal)
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.username)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                    
                    Text(post.content)
                } //: VSTACK
                
                Spacer(minLength: 0)
                
                Button("", systemImage: "ellipsis") {
                    
                }
                .foregroundStyle(.primary)
                .offset(y: -10)
                
            } //: HSTACK
            
            /// Image Carousel using new ScrollVIew (iOS 17+)
            VStack(alignment: .leading, spacing: 10) {
                GeometryReader {
                    let size = $0.size
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            
                            ForEach(post.pics) { pic in
                                /// This Lazy HStack makes images go away too soon from the screen.
                                /// Using SafeAreaPadding instead of normal padding solves this.
                                LazyHStack {
                                    Image(pic.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: size.width)
                                        .clipShape(.rect(cornerRadius: 10, style: .continuous))
                                } //: Lazy HSTACK
                                .frame(maxWidth: size.width)
                                .frame(height: size.height)
                                .anchorPreference(key: OffsetKey.self, value: .bounds, transform: { anchor in
                                    return [pic.id.uuidString: anchor]
                                })
                                .onTapGesture {
                                    selectedPost = post
                                    selectedPicId = pic.id
                                    showDetailView = true
                                }
                                .contentShape(.rect)
                                .opacity(selectedPicId == pic.id ? 0 : 1)
                            }
                            
                        } //: HSTACK
                        .scrollTargetLayout()
                    } //: H Scroll
                    .scrollPosition(id: .init(get: {
                        return post.scrollPosition
                    }, set: { _ in
                        
                    }))
                    .scrollTargetBehavior(.viewAligned)
                    .scrollClipDisabled()
                } //: GEOMETRY
                .frame(height: 200)
                
                /// Image Buttons
                HStack(spacing: 10) {
                    ImageButton("suit.heart") {
                        
                    }
                    
                    ImageButton("message") {
                        
                    }
                    
                    ImageButton("arrow.2.squarepath") {
                        
                    }
                    
                    ImageButton("paperplane") {
                        
                    }
                } //: IMAGE BUTTONS HSTACK
                
            } //: VSTACK
            .safeAreaPadding(.leading, 45) /// <-- To avoid images disappearing too soon
            
            /// Likes & Replies
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                Button("10 replies") {
                    
                }
                
                Button("810 likes") {
                    
                }
                
                Spacer()
            } //: REPLIES AND LIKES HSTACK
            .textScale(.secondary)
            .foregroundStyle(.secondary)
            
        } //: VSTACK
        .background(alignment: .leading) {
            Rectangle()
                .fill(.secondary)
                .frame(width: 1)
                .padding(.bottom, 30)
                .offset(x: 15, y: 10)
        }
        
    }
    
    @ViewBuilder
    private func ImageButton(_ icon: String, onTap: @escaping () -> Void) -> some View {
        Button("", systemImage: icon, action: onTap)
            .font(.title3)
            .foregroundStyle(.primary)
    }
    
}

#Preview {
    Home()
}
