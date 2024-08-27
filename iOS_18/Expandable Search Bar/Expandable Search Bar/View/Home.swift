//
//  Home.swift
//  Expandable Search Bar
//
//  Created by Matteo Buompastore on 27/08/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    @State private var searchText: String = ""
    @State private var progress: CGFloat = 0
    @FocusState private var isFocused: Bool
    
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(sampleItems) { item in
                    CardView(item)
                } //: Loop Items
            } //: Lazy VSTACK
            .padding(15)
            .offset(y: isFocused ? 0 : progress * 75)
            .padding(.bottom, 75)
            .safeAreaInset(edge: .top, spacing: 0) {
                ResizableHeader()
            }
            .scrollTargetLayout()
        } //: V-SCROLL
        .scrollTargetBehavior(CustomScrollTarget())
        .animation(.snappy(duration: 0.3, extraBounce: 0), value: isFocused)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y + geometry.contentInsets.top
        } action: { oldValue, newValue in
            progress = max(min(newValue / 75, 1), 0)
        }

    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func CardView(_ item: Item) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader {
                let size = $0.size
                
                if let image = item.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .clipShape(.rect(cornerRadius: 20))
                }
            } //: GEOMETRY
            .frame(height: 220)
            
            Text("By \(item.title)")
                .font(.callout)
                .foregroundStyle(.primary.secondary)
            
        } //: VSTACK
    }
    
    @ViewBuilder
    private func ResizableHeader() -> some View {
        let progress = isFocused ? 1 : progress
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome Back!")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    
                    Text("Leon")
                        .font(.title.bold())
                    
                } //: VSTACK
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image("Profile 1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                }
            } //: HSTACK
            .frame(height: 60 - (60 * progress), alignment: .bottom)
            .padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 15 - (15 * progress))
            .opacity(1 - progress)
            .offset(y: -10 * progress)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    
                TextField("Search", text: $searchText)
                    .focused($isFocused)
                
                /// Mic Button
                Button {
                    
                } label: {
                    Image(systemName: "microphone.fill")
                        .foregroundStyle(.red)
                }

                
            } //: HSTACK
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: isFocused ? 0 : 30)
                    .fill(
                        .background
                            .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
                            .shadow(.drop(color: .black.opacity(0.05), radius: 5, x: -5, y: -5))
                    )
                    .padding(.top, isFocused ? -100 : 0)
            }
            .padding(.horizontal, isFocused ? 0 : 15)
            .padding(.bottom, 10)
            .padding(.top, 5)
        } //: VSTACK
        .background {
            ProgressiveBlurView()
                .blur(radius: isFocused ? 0 : 10)
                .padding(.horizontal, -15)
                .padding(.bottom, -10)
                .padding(.top, -100)
        }
        .visualEffect { content, proxy in
            content
                .offset(y: offsetY(proxy))
        }
    }
    
    // MARK: Functions
    
    nonisolated
    private func offsetY(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        return minY > 0 ? (isFocused ? -minY : 0) : -minY
    }
    
}

struct CustomScrollTarget: ScrollTargetBehavior {
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let endPoint = target.rect.minY
        
        if endPoint < 75 {
            if endPoint > 59 {
                target.rect.origin = .init(x: 0, y: 75)
            } else {
                target.rect.origin = .zero
            }
        }
    }
    
}

#Preview {
    Home()
}
