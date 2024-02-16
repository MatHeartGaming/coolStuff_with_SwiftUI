//
//  ContentView.swift
//  Draggable Annotation Map Interaction
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    // MARK: - Properties
    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(center: .applePark, span: .initalSpan))
    @State private var coordinate: CLLocationCoordinate2D = .applePark
    @State private var mapSpan: MKCoordinateSpan = .initalSpan
    @State private var annotationTitle: String = ""
    
    @State private var updatesCamera: Bool = false
    @State private var displaysTitle: Bool = false
    
    var body: some View {
        MapReader { proxy in
            Map(position: $camera) {
                
                Annotation(displaysTitle ? annotationTitle : "", coordinate: coordinate) {
                    DraggablePin(proxy: proxy, coordinate: $coordinate) { coordinate in
                        findCoordinateName()
                        guard updatesCamera else { return }
                        /// Optional: Updating camera position when coordinate changes
                        let newRegion = MKCoordinateRegion(
                            center: coordinate,
                            span: mapSpan)
                        
                        withAnimation(.smooth) {
                            camera = .region(newRegion)
                        }
                    }
                } //: ANNOTATION
                
            } //: MAP
            .onMapCameraChange(frequency: .continuous) { ctx in
                mapSpan = ctx.region.span
            }
            .safeAreaInset(edge: .bottom, content: {
                HStack(spacing: 15) {
                    Toggle("Updates Camera", isOn: $updatesCamera)
                        .frame(width: 170)
                    
                    Spacer(minLength: 0)
                    
                    Toggle("Display Title", isOn: $displaysTitle)
                        .frame(width: 170)
                } //: HSTACK Toggles
                .textScale(.secondary)
                .padding(15)
                .background(.ultraThinMaterial)
            })
            .onAppear(perform: findCoordinateName)
            
        } //: MAPREADER
    }
    
    
    // MARK: - Functions
    
    private func findCoordinateName() {
        annotationTitle = ""
        Task {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geoDecoder = CLGeocoder()
            if let name = try? await geoDecoder.reverseGeocodeLocation(location).first?.name {
                self.annotationTitle = name
            }
        }
    }
    
}


// MARK: - Previews
#Preview {
    ContentView()
}
