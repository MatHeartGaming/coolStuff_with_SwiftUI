//
//  VIew+Extensions.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 13/05/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func didFrameChange(result: @escaping (CGRect, CGRect) -> Void) -> some View {
        self
            .overlay {
                GeometryReader {
                    let frame = $0.frame(in: .scrollView(axis: .vertical))
                    let bounds = $0.bounds(of: .scrollView(axis: .vertical)) ?? .zero
                    Color.clear
                        .preference(key: FrameKey.self, value: .init(frame: frame, bounds: bounds))
                        .onPreferenceChange(FrameKey.self, perform: { value in
                            result(value.frame, value.bounds)
                        })
                        
                }
            }
    }
    
}

struct ViewFrame: Equatable {
    var frame: CGRect = .zero
    var bounds: CGRect = .zero
}

struct FrameKey: PreferenceKey {
    
    static var defaultValue: ViewFrame = .init()
    
    static func reduce(value: inout ViewFrame, nextValue: () -> ViewFrame) {
        value = nextValue()
    }
    
}
