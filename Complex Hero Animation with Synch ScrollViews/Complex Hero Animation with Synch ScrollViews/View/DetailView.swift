//
//  DetailView.swift
//  Complex Hero Animation with Synch ScrollViews
//
//  Created by Matteo Buompastore on 12/01/24.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: - PROPERTIES
    @Binding var showDetailView: Bool
    @Binding var detailViewAnimation: Bool
    var post: Post?
    @Binding var selectedPicID: UUID?
    var updateScrollPosition: (UUID) -> Void
    
    /// View Properties
    @State private var detailScrollPosition: UUID?
    
    /// Dispatch Task
    @State private var startTask1: DispatchWorkItem?
    @State private var startTask2: DispatchWorkItem?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(post!.pics) { pic in
                    Image(pic.image)
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .anchorPreference(key: OffsetKey.self, value: .bounds, transform: { anchor in
                            return ["DESTINATION\(pic.id.uuidString)": anchor]
                        })
                        .opacity(selectedPicID == pic.id ? 0 : 1)
                } //: LOOP Pics
            } //: Lazy HSTACK
            .scrollTargetLayout()
        } //: H SCROLL
        .background(.black)
        .opacity(detailViewAnimation ? 1 : 0)
        .scrollPosition(id: $detailScrollPosition)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        /// Close Button
        .overlay(alignment: .topLeading) {
            Button("", systemImage: "xmark.circle.fill") {
                cancelTasks()
                
                updateScrollPosition(detailScrollPosition!)
                selectedPicID = detailScrollPosition
                /// Giving some time to set the scroll position
                initiateTask(ref: &startTask1, task: .init(block: {
                    withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                        detailViewAnimation = false
                    }
                    
                    /// Removing layer view
                    initiateTask(ref: &startTask2, task: .init(block: {
                        showDetailView = false
                        selectedPicID = nil
                    }), duration: 0.3)
                }), duration: 0.05)
                
                
            }
            .font(.title)
            .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
            .padding()
        }
        .onAppear {
            cancelTasks()
            /// Only executes one time
            guard detailScrollPosition == nil else { return }
            detailScrollPosition = selectedPicID
            /// Giving some time to set the scroll position
            initiateTask(ref: &startTask1, task: .init(block: {
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    detailViewAnimation = true
                }
                
                /// Removing layer view
                initiateTask(ref: &startTask2, task: .init(block: {
                    selectedPicID = nil
                }), duration: 0.3)
            }), duration: 0.05)
            
        }
    }
    
    private func initiateTask(ref: inout DispatchWorkItem?, task: DispatchWorkItem, duration: CGFloat) {
        ref = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    /// Cancelling previous tasks
    private func cancelTasks() {
        startTask1?.cancel()
        startTask2?.cancel()
        startTask1 = nil
        startTask2 = nil
    }
    
}

#Preview {
    let pics: [PicItem] = [.init(image: "Pic 1"), .init(image: "Pic 2")]
    return DetailView(showDetailView: .constant(true),
                      detailViewAnimation: .constant(true),
                      post: samplePosts.first!,
                      selectedPicID: .constant(pics.first!.id)) { id in
        
    }
}

#Preview {
    ContentView()
}
