//
//  ContentView.swift
//  AnimatedTagsView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - UI
    @State private var tags: [String] = [
        "SwiftUI", "Swift", "ioS", "Apple", "Xcode", "Xcode", "WWDC", "App", "Indie", "Developer", "Objc", "Macbook",
        "iPados", "C#", "C", "macOS", "Android", "React", "Flutter", "C++", "iPhone", "iPad"]
    
    /// Selection
    @State private var selectedTags = [String]()
    
    /// Adding Matched Geometry Effect
    @Namespace private var animation
    
    var body: some View {
        
        let disableButton: Bool = selectedTags.count < 3
        
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(selectedTags, id: \.self) { tag in
                        TagView(tag, .pink, "checkmark")
                            .matchedGeometryEffect(id: tag, in: animation)
                            /// Removing from selected List
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedTags.removeAll(where: { $0 == tag })
                                }
                            }
                    } //: LOOP
                } //: HSTACK
                .padding(.horizontal, 15)
                .frame(height: 35)
                .padding(.vertical, 15)
            } //: H - SCROLL
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .overlay {
                if selectedTags.isEmpty {
                    Text("Select more than 3 tags")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .background(.white)
            .zIndex(1)
            
            ScrollView(.vertical) {
                TagLayout(alignment: .center, spacing: 10) {
                    ForEach(tags.filter({ !selectedTags.contains($0) }), id: \.self) { tag in
                        TagView(tag, .blue, "plus")
                            .matchedGeometryEffect(id: tag, in: animation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    if !selectedTags.contains(tag) {
                                        selectedTags.insert(tag, at: .zero)
                                    }
                                }
                            }
                    }
                }
                .padding(15)
            } //: V - SCROLL
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .background(.black.opacity(0.05))
            .zIndex(0)
            
            ZStack {
                
                Button(action: {}, label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.pink.gradient)
                        )
                }) //: BUTTON
                /// Disabling until 3 or more tags are selected
                .disabled(disableButton)
                .opacity(disableButton ? 0.5 : 1)
                .padding()
                
            } //: ZSTACK
            .background(.white)
            
        } //: VSTACK
    }
    
    @ViewBuilder
    func TagView(_ tag: String, _ color: Color, _ icon: String) -> some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            
            Image(systemName: icon)
        } //: HSTACK
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background(
            Capsule()
                .fill(color.gradient)
        )
    }
    
}

#Preview {
    ContentView()
}
