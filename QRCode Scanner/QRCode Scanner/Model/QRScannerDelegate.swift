//
//  QRScannerDelegate.swift
//  QRCode Scanner
//
//  Created by Matteo Buompastore on 09/01/24.
//

import SwiftUI
import AVKit

class QRScannerDelegate: NSObject, ObservableObject,  AVCaptureMetadataOutputObjectsDelegate {
    
    @Published var scannedCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            guard let scannedCode = readableObject.stringValue else { return }
            
            print("Scanned Code: \(scannedCode)")
            self.scannedCode = scannedCode
        }
    }
    
}
