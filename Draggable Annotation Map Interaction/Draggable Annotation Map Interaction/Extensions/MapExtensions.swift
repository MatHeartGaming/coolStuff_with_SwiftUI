//
//  MapExtensions.swift
//  Draggable Annotation Map Interaction
//
//  Created by Matteo Buompastore on 16/02/24.
//

import MapKit

extension MKCoordinateSpan {
    
    static var initalSpan: MKCoordinateSpan {
        return .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
}

extension CLLocationCoordinate2D {
    
    static var applePark: CLLocationCoordinate2D {
        return .init(latitude: 37.334606, longitude: -122.009102)
    }
    
}
