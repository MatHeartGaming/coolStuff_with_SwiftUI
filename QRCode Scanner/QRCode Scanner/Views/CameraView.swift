//
//  CameraView.swift
//  QRCode Scanner
//
//  Created by Matteo Buompastore on 09/01/24.
//

import SwiftUI
import AVKit

/// Camera view using AVCaptureVideoPreviewLayer
struct CameraView: UIViewRepresentable {
    
    var frameSize: CGSize
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraLayer)
        cameraLayer.masksToBounds = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

#Preview {
    GeometryReader {
        CameraView(frameSize: $0.size, session: .constant(.init()))
    }
}
