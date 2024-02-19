//
//  Extensions.swift
//  Sticky Header Autoscrollable Tabs
//
//  Created by Matteo Buompastore on 19/02/24.
//

import SwiftUI

extension [Product] {
    
    /// Return the array's first product type
    var type: ProductType {
        if let firstProduct = self.first {
            return firstProduct.type
        }
        return .iphone
    }
    
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    
}

extension View {
    
    @ViewBuilder
    func offset(_ coordinateSpace: AnyHashable, completion: @escaping (CGRect) -> Void) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .named(coordinateSpace))
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            completion(value)
                        })
                }
            }
    }
    
}


extension View {
    
    @ViewBuilder
    func checkAnimationEnd<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> some View {
        self
            .modifier(AnimationEndCallback(for: value, onEnd: completion))
    }
    
}

/// Animation OnEnd Callback
fileprivate struct AnimationEndCallback<Value: VectorArithmetic>: Animatable, ViewModifier {
    
    var animatableData: Value {
        didSet {
            checkIfFinished()
        }
    }
    
    var endValue: Value
    var onEnd: () -> Void
    
    init(for value: Value, onEnd: @escaping () -> Void) {
        self.animatableData = value
        self.endValue = value
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    private func checkIfFinished() {
        if endValue == animatableData {
            DispatchQueue.main.async {
                onEnd()
            }
        }
    }
    
}
