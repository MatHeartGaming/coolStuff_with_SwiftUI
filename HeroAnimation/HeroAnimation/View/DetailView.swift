//
//  DetailView.swift
//  HeroAnimation
//
//  Created by Matteo Buompastore on 01/12/23.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: - PROPERTIES
    @Binding var selectedProfile: Profile?
    @Binding var heroProgress: CGFloat
    @Binding var showDetail: Bool
    @Binding var showHeroView: Bool
    @Environment(\.colorScheme) private var scheme
    /// Gesture
    @GestureState private var isDragging = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        if let selectedProfile, showDetail {
            GeometryReader { geometry in
                let size = geometry.size
                
                ScrollView(.vertical) {
                    
                    Rectangle()
                        .fill(.clear)
                        .overlay {
                            if !showHeroView {
                                Image(selectedProfile.profilePicture)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: size.width, height: 400)
                                    .clipShape(.rect(cornerRadius: 25))
                                    .transition(.identity)
                            }
                                
                        }
                        .frame(height: 400)
                        /// Destination Frame
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return ["DESTINATION": anchor]
                        })
                        .visualEffect { content, geometryProxy in
                            content
                                .offset(y: geometryProxy.frame(in: .scrollView).minY > 0 ? -geometryProxy.frame(in: .scrollView).minY : 0)
                        }
                } //: SCROLL
                .scrollIndicators(.hidden)
                .ignoresSafeArea()
                .frame(width: size.width, height: size.height)
                .background(
                    Rectangle()
                        .fill(scheme == .dark ? .black : .white)
                        .ignoresSafeArea()
                )
                .overlay(alignment: .topLeading) {
                    Button(action: {
                        self.showHeroView = true
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete, {
                            heroProgress = 0
                        }, completion: {
                            showDetail = false
                            self.selectedProfile = nil
                        })
                        
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .contentShape(.rect)
                            .foregroundStyle(.white, .black)
                    })
                    .buttonStyle(.plain)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.snappy(duration: 0.2, extraBounce: 0), value: showHeroView)
                } //: OVERLAY XMARK
                .offset(x: size.width - (size.width * heroProgress))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 10)
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { value, state, transaction in
                                    state = true
                                })
                                .onChanged({ value in
                                    var translation = value.translation.width
                                    translation = isDragging ? translation : .zero
                                    translation = translation > 0 ? translation : .zero
                                    /// Convert into progress
                                    let dragProgress = 1.0 - (translation / size.width)
                                    /// Limiting progress btw 0 - 1
                                    let cappedProgress = min(max(0, dragProgress), 1)
                                    heroProgress = cappedProgress
                                    if !showHeroView {
                                        showHeroView = true
                                    }
                                })
                                .onEnded({ value in
                                    /// Close / Resetting based on end target
                                    let velocity = value.velocity.width
                                    if (offset + velocity) > (size.width * 0.8) {
                                        /// Close view
                                        withAnimation(.snappy(duration: 0.35), completionCriteria: .logicallyComplete) {
                                            heroProgress = 0
                                        } completion: {
                                            offset = .zero
                                            showDetail = false
                                            showHeroView = true
                                            self.selectedProfile = nil
                                        }
                                    } else {
                                        /// Reset
                                        withAnimation(.snappy(duration: 0.35), completionCriteria: .logicallyComplete) {
                                            heroProgress = 1
                                        } completion: {
                                            showHeroView = false
                                        }
                                    }
                                })
                        )
                }
            } //: GEOMETRY
        }
    }
}

#Preview {
    DetailView(selectedProfile: .constant(profiles.first), 
               heroProgress: .constant(1),
               showDetail: .constant(true),
               showHeroView: .constant(false)
    )
}
