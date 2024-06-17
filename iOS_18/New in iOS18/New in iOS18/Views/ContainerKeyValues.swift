//
//  ContainerKeyValues.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

/// Every individual view has container values, which the subview can read
struct ContainerKeyValues: View {
    
    var body: some View {
        CustomView {
            ForEach(1...10, id: \.self) { index in
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                    .containerValue(\.floatIndex, CGFloat(index))
            }
        }
        .padding(15)
    }
    
}

struct CustomView<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(subviewOf: content) { subview in
                let index = subview.containerValues.floatIndex
                
                subview
                    .overlay {
                        Text("\(index)")
                    }
            }
        } //: VSTACK
    }
}

struct ViewKey: ContainerValueKey {
    static var defaultValue: CGFloat = 0
}

extension ContainerValues {
    var floatIndex: CGFloat {
        get {
            self[ViewKey.self]
        }
        set {
            self[ViewKey.self] = newValue
        }
    }
}

#Preview {
    ContainerKeyValues()
}
