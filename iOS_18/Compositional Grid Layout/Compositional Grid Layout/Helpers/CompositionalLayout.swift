//
//  CompositionalLayout.swift
//  Compositional Grid Layout
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

struct CompositionalLayout<Content: View>: View {
    
    // MARK: Properties
    var count: Int = 3
    var spacing: CGFloat = 6
    @ViewBuilder var content: Content
    @Namespace private var animation
    
    
    var body: some View {
        Group(subviewsOf: content) { collection in
            let chunked = collection.chunked(count)
            
            ForEach(chunked) { chunk in
                switch chunk.layoutID {
                    case 0: Layout1(chunk.collection)
                    case 1: Layout2(chunk.collection)
                    case 2: Layout3(chunk.collection)
                    default: Layout4(chunk.collection)
                }
            }
        }
    }
    
    @ViewBuilder
    private func Layout1(_ collection: [SubviewsCollection.Element]) -> some View {
        GeometryReader {
            let width = $0.size.width - spacing
            HStack(spacing: spacing) {
                if let first = collection.first {
                    first
                        .matchedGeometryEffect(id: first.id, in: animation)
                }
                
                VStack(spacing: spacing) {
                    ForEach(collection.dropFirst()) {
                        $0
                            .matchedGeometryEffect(id: $0.id, in: animation)
                            .frame(width: width * 0.33)
                    }
                } //: VSTACK
            } //: HSTACK
        } //: GEOMETRY
        .frame(height: 200)
    }
    
    @ViewBuilder
    private func Layout2(_ collection: [SubviewsCollection.Element]) -> some View {
        HStack(spacing: spacing) {
            ForEach(collection) {
                $0
                    .matchedGeometryEffect(id: $0.id, in: animation)
            }
        } //: HSTACK
        .frame(height: 100)
    }
    
    @ViewBuilder
    private func Layout3(_ collection: [SubviewsCollection.Element]) -> some View {
        GeometryReader {
            let width = $0.size.width - spacing
            HStack(spacing: spacing) {
                if let first = collection.first {
                    first
                        .matchedGeometryEffect(id: first.id, in: animation)
                        .frame(width: collection.count == 1 ? width : width * 0.33)
                }
                
                VStack(spacing: spacing) {
                    ForEach(collection.dropFirst()) {
                        $0
                            .matchedGeometryEffect(id: $0.id, in: animation)
                    }
                } //: VSTACK
            } //: HSTACK
        } //: GEOMETRY
        .frame(height: 200)
    }
    
    @ViewBuilder
    private func Layout4(_ collection: [SubviewsCollection.Element]) -> some View {
        HStack(spacing: spacing) {
            ForEach(collection) {
                $0
                    .matchedGeometryEffect(id: $0.id, in: animation)
            }
        } //: HSTACK
        .frame(height: 230)
    }
}

fileprivate extension SubviewsCollection {
    func chunked(_ size: Int) -> [ChunkedCollection] {
        stride(from: 0, to: count, by: size).map {
            let collection = Array(self[$0..<Swift.min($0 +  size, count)])
            /// 4 is the number of layouts used in this example
            let layoutID = ($0 / size) % 4
            return .init(layoutID: layoutID, collection: collection)
        }
    }
    
    struct ChunkedCollection: Identifiable {
        let id = UUID()
        var layoutID: Int
        var collection: [SubviewsCollection.Element]
    }
}

#Preview {
    ContentView()
}
