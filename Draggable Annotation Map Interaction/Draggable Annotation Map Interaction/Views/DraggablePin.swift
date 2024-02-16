//
//  DraggablePin.swift
//  Draggable Annotation Map Interaction
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI
import MapKit

struct DraggablePin: View {
    
    //MARK: - Properties
    var tint: Color = .red
    var proxy: MapProxy
    @Binding var coordinate: CLLocationCoordinate2D
    var onCoordinateChange: (CLLocationCoordinate2D) -> Void
    @State private var isActive: Bool = false
    @State private var translation: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            Image(systemName: "mappin")
                .font(.title)
                .foregroundStyle(tint.gradient)
                .animation(.snappy, body: { content in
                    content
                        .scaleEffect(isActive ? 1.3 : 1, anchor: .bottom)
                })
                .frame(width: frame.width, height: frame.height)
                .onChange(of: isActive) { oldValue, newValue in
                    let position = CGPoint(x: frame.midX, y: frame.midY)
                    /// Converting Postion into Location Coordinate usin Map Proxy
                    if let coordinate = proxy.convert(position, from: .global),
                            /// To avoid the AnnotationTItle to blink when tapped on
                            !newValue {
                        /// Updating coordinate based on translation and resetting to 0
                        self.coordinate = coordinate
                        translation = .zero
                        onCoordinateChange(coordinate)
                    }
                }
                
        } //: GEOMETRY
        .frame(width: 30, height: 30)
        .contentShape(.rect)
        .offset(translation)
        .gesture(
            LongPressGesture(minimumDuration: 0.15)
                .onEnded { newValue in
                    isActive = newValue
                }
                .simultaneously(with:
                                    DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if isActive {
                            translation = value.translation
                        }
                    }
                    .onEnded { value in
                        if isActive {
                            isActive = false
                        }
                    }
                )
        ) //: Long Press Gesture
    }
}

#Preview {
    @State var applePark: CLLocationCoordinate2D = .applePark
    return MapReader { proxy in
        DraggablePin(proxy: proxy, coordinate: $applePark) { coordinate in
            
        }
    }
}


#Preview {
    ContentView()
}
