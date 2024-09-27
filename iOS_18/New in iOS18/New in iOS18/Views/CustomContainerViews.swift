//
//  CustomContainerViews.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

/// Until now it was not possible to distinguish subviews under a @ViewBuilder function.
/// Now it is possible by using ForEach and Group to distinguish individual subviews, getting their indexes and make adjustments based on that.
/// It is even possible to disinguish between lists of Sections passed by the @ViewBuilder
struct CustomContainerGroupViews: View {
    var body: some View {
        CustomViewGroup {
            ForEach(0...10, id: \.self) { index in
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                    .frame(height: 45)
            } //: Loop Views
        } // Custom View
        .padding(15)
    }
}

struct CustomViewGroup<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 10) {
            Group(subviews: content) { collection in
                ForEach(collection) { subview in
                    let index = collection.firstIndex(where: { $0.id == subview.id })
                    subview
                        .overlay {
                            if let index {
                                Text("\(index)")
                                    .font(.largeTitle.bold())
                            }
                        }
                }
            }
        }
    }
    
}

struct CustomContainerSectionViews: View {
    var body: some View {
        CustomViewSection {
            ForEach(0...10, id: \.self) { index in
                Section {
                    Text("Content")
                } header: {
                    Text("Header")
                }
            } //: Loop Sections
        } // Custom View
        .padding(15)
    }
}


struct CustomViewSection<Content: View>: View {
    @ViewBuilder var content: Content
    
    fileprivate func standardWay(_ collection: SectionCollection) -> ForEach<SectionCollection, SectionConfiguration.ID, VStack<TupleView<(SubviewsCollection, SubviewsCollection)>>> {
        return ForEach(collection) { section in
            VStack(alignment: .leading, spacing: 15) {
                section.content
                section.header
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Group(sections: content) { collection in
                //standardWay(collection)
                
                /// Since SubView collections conforms to RandomAccessCollection we can use subscripts too.
                if collection.count >= 1 {
                    collection[1].content
                }
            } //: Group
        }
    }
    
}

#Preview {
    CustomContainerGroupViews()
}

#Preview {
    CustomContainerSectionViews()
}
