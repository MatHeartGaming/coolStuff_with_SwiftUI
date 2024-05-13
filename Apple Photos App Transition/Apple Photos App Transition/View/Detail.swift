//
//  Detail.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

struct Detail: View {
    
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        VStack(spacing: 0) {
            
            NavigationBar()
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(coordinator.items) { item in
                            ImageView(item, size: size)
                        } //: Loop Items
                    } //: Lazy H-STACK
                    .scrollTargetLayout()
                } //: H-SCROLL
                /// Making it a paging virew
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .scrollPosition(id: .init(get: {
                    return coordinator.detailScrollPosition
                }, set: { id in
                    coordinator.detailScrollPosition = id
                }))
                .onChange(of: coordinator.detailScrollPosition, { oldValue, newValue in
                    withAnimation(.smooth(duration: 0.15)) {
                        coordinator.didDetailPageChanged()
                    }
                })
                .background {
                    if let selectedItem = coordinator.selectedItem {
                        Rectangle()
                            .fill(.clear)
                            .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                                return [selectedItem.id + "DEST": anchor]
                            })
                    }
                }
                .offset(coordinator.offset)
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 10)
                    .contentShape(.rect)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged{ value in
                                let translation = value.translation
                                coordinator.offset = translation
                                /// Progress for Fading Out the Detail View
                                let heightProgress = max(min(translation.height / 200, 1), 0)
                                coordinator.dragProgress = heightProgress
                            }
                            .onEnded{ value in
                                let translation = value.translation
                                let velocity = value.velocity
                                //let width = translation.width + (velocity.width / 5)
                                let height = translation.height + (velocity.height / 5)
                                if height > (size.height * 0.5) {
                                    /// Close View
                                    coordinator.toggleView(show: false)
                                } else {
                                    /// Reset to origin
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        coordinator.offset = .zero
                                        coordinator.dragProgress = .zero
                                    }
                                }
                            }
                    )
                
            } //: GEOMETRY
            .opacity(coordinator.showDetailView ? 1 : 0)
            
            BottomIndicatorView()
                .offset(y: coordinator.showDetailView ? (120 * coordinator.dragProgress) : 120)
                .animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
            
        } //: VSTACK
        .onAppear {
            coordinator.toggleView(show: true)
        }
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func ImageView(_ item: Item, size: CGSize) -> some View {
        if let image = item.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .clipped()
                .contentShape(.rect)
        }
    }
    
    @ViewBuilder
    private func NavigationBar() -> some View {
        HStack {
            Button(action: {
                coordinator.toggleView(show: false)
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                    Text("Back")
                } //: HSTACK
            })
            
            Spacer(minLength: 0)
            
            Button(action: {}, label: {
                Image(systemName: "ellipsis")
                    .padding(10)
                    .background(.bar, in: .circle)
            })
        } //: HSTACK
        .padding([.top, .horizontal], 15)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .offset(y: coordinator.showDetailView ? (-120 * coordinator.dragProgress) : -120)
        .animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
    }
    
    /// Bottom Indicator View
    @ViewBuilder
    private func BottomIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 5) {
                    ForEach(coordinator.items) { item in
                        if let image = item.previewImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(.rect(cornerRadius: 10))
                                .scaleEffect(0.97)
                        }
                    }
                } //: Lazy H-Stack
                .padding(.vertical, 10)
                .scrollTargetLayout()
            } //: H-SCROLL
            /// 50 - item size inside ScrollView
            .safeAreaPadding(.horizontal, (size.width - 50) / 2)
            .overlay {
                /// Active Indicator Icon
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 50, height: 50)
                    .allowsHitTesting(false)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                return coordinator.detailIndicatorPosition
            }, set: {
                coordinator.detailIndicatorPosition = $0
            }))
            .scrollIndicators(.hidden)
            .onChange(of: coordinator.detailIndicatorPosition) { oldValue, newValue in
                coordinator.didDetailIndicatorPageChanged()
            }
        } //: GEOMETRY
        .frame(height: 70)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
    
}

#Preview {
    Detail()
        .environment(UICoordinator())
}

#Preview {
    ContentView()
}
