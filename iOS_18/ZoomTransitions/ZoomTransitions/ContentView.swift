//
//  ContentView.swift
//  ZoomTransitions
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    var sharedModel = SharedModel()
    @Namespace private var animation
    
    var body: some View {
        @Bindable var bindings = sharedModel
        GeometryReader {
            let screenSize = $0.size
            NavigationStack {
                VStack(spacing: 0) {
                    HeaderView()
                    
                    ScrollView(.vertical) {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                            ForEach($bindings.videos) { $video in
                                NavigationLink(value: video) {
                                    CardView(screenSize: screenSize, video: $video)
                                        .environment(sharedModel)
                                        .frame(height: screenSize.height * 0.4)
                                        .matchedTransitionSource(id: video.id, in: animation) {
                                            $0
                                                .background(.clear)
                                                .clipShape(.rect(cornerRadius: 15))
                                        }
                                } //: NavLink
                                .buttonStyle(CustomButtonStyle())
                            } //: Loop Videos
                        } //: Lazy VGRID
                    } //: SCROLL
                    .scrollIndicators(.hidden)
                    .padding(15)
                } //: VSTACK
                .ignoresSafeArea(.container, edges: [.bottom])
                .navigationDestination(for: Video.self) { video in
                    DetailView(video: video, animation: animation)
                        .environment(sharedModel)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                }
            } //: NAVIGATION
        } //: GEOMETRY
    }
    
    private func HeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }

            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
            }
            
        } //: HSTACK
        .overlay {
            Text("Stories")
                .font(.title3.bold())
        }
        .foregroundStyle(Color.primary)
        .padding(15)
        .background(.ultraThinMaterial)
        
    }
    
}

struct CardView: View {
    
    // MARK: Properties
    var screenSize: CGSize
    @Binding var video: Video
    @Environment(SharedModel.self) private var sharedModel
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            if let thumbnail = video.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.fill)
                    .task(priority: .high) {
                        await sharedModel.generateThumbnails($video, size: screenSize)
                    }
            }
            
        } //: GEOMETRY
    }
    
}

/// Custom Button Style
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    ContentView()
}
