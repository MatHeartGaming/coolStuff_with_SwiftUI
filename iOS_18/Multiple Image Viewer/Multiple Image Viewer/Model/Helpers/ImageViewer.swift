//
//  ImageViewer.swift
//  Multiple Image Viewer
//
//  Created by Matteo Buompastore on 02/01/25.
//

import SwiftUI

struct ImageViewer<Content: View, Overlay: View>: View {
    
    // MARK: Properties
    var config = Config()
    @ViewBuilder var content: Content
    @ViewBuilder var overlay: Overlay
    var updates: (Bool, AnyHashable?) -> Void = { _, _ in }
    
    /// UI
    @State private var isPresented: Bool = false
    @State private var activeTabID: Subview.ID?
    @State private var transitionSource: Int = 0
    @Namespace private var animation
    
    var body: some View {
        /// Using new 18+ API to retrieve the Subview collection
        Group(subviews: content) { collection in
            LazyVGrid(columns: Array(repeating: GridItem(spacing: config.spacing), count: 2), spacing: config.spacing) {
                
                let remainingCount = max(collection.count - 4, 0)
                /// Only displaying the first 4 images
                ForEach(collection.prefix(4)) { item in
                    let index = collection.index(item.id)
                    GeometryReader {
                        let size = $0.size
                        
                        item
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: config.cornerRadius))
                        
                        if collection.prefix(4).last?.id == item.id && remainingCount > 0 {
                            RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                                .fill(.black.opacity(0.35))
                                .overlay {
                                    Text("+\(remainingCount)")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                        }
                        
                    } //: GEOMETRY
                    .frame(height: config.height)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        activeTabID = item.id
                        isPresented = true
                        transitionSource = index
                    }
                    /// Indexes greater than 4 will always be 4
                    .matchedTransitionSource(id: index, in: animation) { config in
                        config
                            .clipShape(.rect(cornerRadius: self.config.cornerRadius, style: .continuous))
                    }
                }
                
            } //: Lazy VGRID
            .navigationDestination(isPresented: $isPresented) {
                TabView(selection: $activeTabID) {
                    ForEach(collection) { item in
                        item
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(item.id)
                    } //: Loop Collection
                } //: TABVIEW
                .tabViewStyle(.page)
                .background {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                }
                .overlay {
                    overlay
                }
                .navigationTransition(.zoom(sourceID: transitionSource, in: animation))
                .toolbarVisibility(.hidden, for: .navigationBar)
            } //: Nav Dest
            /// Updating Transition Source when tab item is changed
            .onChange(of: activeTabID) { oldValue, newValue in
                transitionSource = min(collection.index(newValue), 3)
                
                sendUpdate(collection, id: newValue)
            }
            .onChange(of: isPresented) { oldValue, newValue in
                sendUpdate(collection, id: activeTabID)
            }
            
        } //: GROUP
    }
    
    
    // MARK: Functions
    
    private func sendUpdate(_ collection: SubviewsCollection, id: Subview.ID?) {
        if let viewID = collection.first(where: { $0.id == id })?.containerValues.activeViewID {
            updates(isPresented, viewID)
        }
    }
    
}

struct Config {
    var height: CGFloat = 150
    var cornerRadius: CGFloat = 10
    var spacing: CGFloat = 10
}

/// To get the current active ID we can use ContainerValues to pass the ID to the view and then extract it from the subview
extension ContainerValues {
    @Entry var activeViewID: AnyHashable?
}

extension SubviewsCollection {
    
    func index(_ id: SubviewsCollection.Element.ID?) -> Int {
        firstIndex(where: { $0.id == id }) ?? 0
    }
}

// MARK: Previews
#Preview {
    ImageViewer {
        
    } overlay: {
        
    }
}

#Preview {
    ContentView()
}
