//
//  ExpandedBottomSheet.swift
//  Apple Music Bottom Sheet Animation
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    
    // MARK: - Properties
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    /// UI
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                
                /// Making it rounded with device corner radius
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(.BG)
                            .opacity(animateContent ? 1 : 0)
                    }
                    .overlay(alignment: .top) {
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                        /// Disabling Interaction since it is not necessary here
                            .allowsTightening(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                
                VStack(spacing: 15) {
                    /// Grab Indicator
                    Capsule()
                        .fill(.white.opacity(0.75))
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                        /// Matching slide animation
                        .offset(y: animateContent ? 0 : size.height)
                    
                    /// Artwork
                    GeometryReader {
                        let size = $0.size
                        
                        Image(.artwork)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: animateContent ? 15 : 5, style: .continuous))
                    }
                    /// Matched Geometry Effect ALWAYS BEFORE the frame modifier
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                    /// Square Image (width - 50) since horizontal padding is 25
                    .frame(height: size.width - 50)
                    /// For small devices padding will be 10, otherwise 30
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    /// Player Video
                    PlayerView(minSize: size)
                    /// Moving it from Bottom
                        .offset(y: animateContent ? 0 : size.height)
                    
                } //: VSTACK
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
                /// For UI Testing
//                .onTapGesture {
//                    withAnimation(.easeInOut(duration: 0.3)) {
//                        expandSheet = false
//                        animateContent = false
//                    }
//                }
                
            } //: ZSTACK
            .contentShape(.rect)
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    })
                    .onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = 0
                            }
                            
                            
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        } //: GEOMETRY
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func PlayerView(minSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            /// Dynamic spacing using available height
            let spacing = size.height * 0.04
            
            /// Make the View occupy all the available space both vertically and horizontally
            VStack(spacing: spacing) {
                /// Artwork and song Name
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Charlie Brown")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Coldplay")
                                .foregroundStyle(.gray)
                        } //: VSTACK
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {}, label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        })
                        
                    } //: HSTACK
                    
                    /// Time line
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top, spacing)
                    
                    /// Timing Label
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("4:03")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                    } //: HSTACK
                    
                    
                } //: VSTACK Artwork, song name, time
                .frame(height: size.height / 2.5, alignment: .top)
                
                /// Play Controls
                HStack(spacing: size.width * 0.18) {
                    Button(action: {}, label: {
                        Image(systemName: "backward.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    })
                    
                    Button(action: {}, label: {
                        Image(systemName: "pause.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    })
                    
                    Button(action: {}, label: {
                        Image(systemName: "forward.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    })
                } //: HSTACK
                .foregroundStyle(.white)
                .frame(maxHeight: .infinity)
                
                /// Volume & other controls
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.gray)
                        
                    } //: HSTACK
                    
                    HStack(alignment: .top, spacing: size.width * 0.18) {
                        
                        Button(action: {}, label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        })
                        
                        VStack(spacing: 6) {
                            Button {
                                
                            } label: {
                                Image(systemName: "airpods.gen3")
                            }
                            
                            Text("MatBuompy's Airpods")
                                .font(.caption)

                        } //: VSTACK
                        
                        Button(action: {}, label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        })
                        
                        
                    } //: HSTACK
                    .foregroundStyle(.white)
                    .blendMode(.overlay)
                    .padding(.top, spacing)
                    
                } //: VSTACK
                /// Moving to bottom
                .frame(height: size.height / 2.5, alignment: .bottom)
                
            } //: VSTACK
        }
    }
    
}


extension View {
    
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
        }
        return 0
    }
    
}

#Preview {
    @State var expand: Bool = false
    @Namespace var animation

    return ExpandedBottomSheet(expandSheet: $expand, animation: animation)
        .preferredColorScheme(.dark)
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
