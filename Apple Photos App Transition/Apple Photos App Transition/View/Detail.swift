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
                .scrollPosition(id: .init(get: {
                    return coordinator.detailScrollPosition
                }, set: { id in
                    coordinator.detailScrollPosition = id
                }))
                .onChange(of: coordinator.detailScrollPosition, { oldValue, newValue in
                    coordinator.didDetailPageChanged()
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
            } //: GEOMETRY
        } //: VSTACK
        .opacity(coordinator.showDetailView ? 1 : 0)
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
        .offset(y: coordinator.showDetailView ? 0 : -120)
        .animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
    }
    
}

#Preview {
    Detail()
        .environment(UICoordinator())
}

#Preview {
    ContentView()
}
