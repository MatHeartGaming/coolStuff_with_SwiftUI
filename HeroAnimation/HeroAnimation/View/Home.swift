//
//  Home.swift
//  HeroAnimation
//
//  Created by Matteo Buompastore on 01/12/23.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    @State private var allProfiles: [Profile] = profiles
    /// Detail properties
    @State private var selectedProfile: Profile?
    @State private var showDetail = false
    @State private var heroProgress: CGFloat = .zero
    @State private var showHeroView: Bool = true
    
    var body: some View {
        NavigationStack {
            List(allProfiles) { profile in
                HStack(spacing: 12) {
                    Image(profile.profilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                        .opacity(selectedProfile?.id == profile.id ? 0 : 1)
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return [profile.id.uuidString: anchor]
                        })
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(profile.userName)
                            .fontWeight(.semibold)
                        
                        Text(profile.lastMsg)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    } //: VSTACK
                } //: HSTACK
                .onTapGesture {
                    selectedProfile = profile
                    showDetail = true
                    
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                        heroProgress = 1
                    } completion: {
                        Task {
                            try? await Task.sleep(for: .seconds(0.1))
                            showHeroView = false
                        }
                    }
                }
            } //: LIST
            .navigationTitle("Progress Effect")
        } //: NAVIGATION
        .overlay {
            DetailView(selectedProfile: $selectedProfile, 
                       heroProgress: $heroProgress,
                       showDetail: $showDetail,
                       showHeroView: $showHeroView)
        }
        /// Hero Animation Layer
        .overlayPreferenceValue(AnchorKey.self, { value in
            GeometryReader(content: { geometry in
                /// Check whether we have both source and destination frames
                if let selectedProfile,
                   let source = value[selectedProfile.id.uuidString],
                   let destination = value["DESTINATION"] {
                    let sourceRect = geometry[source]
                    let destinationRect = geometry[destination]
                    let radius = sourceRect.height / 2
                    
                    let diffSize = CGSize(
                        width: destinationRect.width - sourceRect.width,
                        height: destinationRect.height - sourceRect.height
                    )
                    
                    let diffOrigin = CGPoint(
                        x: destinationRect.minX - sourceRect.minX,
                        y: destinationRect.minY - sourceRect.minY
                    )
                    
                    /// Place your Hero View
                    
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: sourceRect.width + (diffSize.width * heroProgress),
                            height: sourceRect.height + (diffSize.height * heroProgress)
                        )
                        .clipShape(.rect(cornerRadius: radius + (radius * heroProgress)))
                        .offset(
                            x: sourceRect.minX + (diffOrigin.x * heroProgress),
                            y: sourceRect.minY + (diffOrigin.y * heroProgress)
                        )
                        .opacity(showHeroView ? 1 : 0)
                }
            })
        })
        /*.overlay(alignment: .bottom) {
            Slider(value: $heroProgress)
                .padding()
        }*/
    }
}

#Preview {
    Home()
}
