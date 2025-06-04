//
//  SwiftUIView.swift
//  UsefulModifiers
//
//  Created by Matteo Buompastore on 04/06/25.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Rectangle()
            .containerRelativeFrame(.vertical) { value, _ in
                value * 0.5
            }
    }
}

struct SwiftUIViewContainerBackground: View {
    var body: some View {
        NavigationStack {
            Text("Home")
                .navigationTitle("Hello")
                /// iOS 18+. Modifiy the background of Navigation and Nav Split Views
                .containerBackground(.blue, for: .navigation)
        }
        .background(.red)
    }
}

struct SwiftUIViewSensoryFeedback: View {
    
    @State var haptics: Bool = false
    
    var body: some View {
        Button("Trigger Haptic Feedback") {
            haptics.toggle()
        }
        /// Vibration
        .sensoryFeedback(.warning, trigger: haptics)
    }
}

struct SwiftUIViewButtonRepeatBehaviour: View {
    
    @State var count: Int = 0
    
    var body: some View {
        Button("Add to Card \(count)") {
            count += 1
        }
        .buttonRepeatBehavior(.enabled)
    }
}

struct SwiftUIViewContentMargins: View {
    
    var body: some View {
        ScrollView(.vertical) {
            Rectangle()
                .fill(.blue)
                .containerRelativeFrame(.vertical) { value, _ in
                    value * 5
                }
        }
        /// Add margins to the scroll indicator
        .contentMargins(.vertical, 50, for: .scrollIndicators)
        .contentMargins(.trailing, 50, for: .scrollIndicators)
        .contentMargins(.vertical, 20, for: .scrollContent)
        .contentMargins(.trailing, 10, for: .scrollContent)
    }
}

struct SwiftUIViewSubViews: View {

    var body: some View {
        let customContent = ForEach(0...10, id: \.self) { _ in
            Rectangle()
        }
        
        Group(subviews: customContent) { collection in
            Text("The given view contains \(collection.count) subviews")
            //collection
        }
    }
}

#Preview("SubViews") {
    SwiftUIViewSubViews()
}


#Preview("Content Margins") {
    SwiftUIViewContentMargins()
}

#Preview("Button Repeat behaviour") {
    SwiftUIViewButtonRepeatBehaviour()
}

#Preview("Container Relative Frame") {
    SwiftUIView()
}

#Preview("Container Background") {
    SwiftUIViewContainerBackground()
}
