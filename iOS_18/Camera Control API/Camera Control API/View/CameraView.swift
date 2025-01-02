//
//  Camera View.swift
//  Camera Control API
//
//  Created by Matteo Buompastore on 02/01/25.
//

import SwiftUI
import AVKit

enum CameraPermission: String {
    case granted = "Permission Granted"
    case denied = "Permission Denied"
    case idle = "Permission Idle"
}

@MainActor
@Observable
class Camera: NSObject, AVCaptureSessionControlsDelegate {
    
    private let queue: DispatchSerialQueue = .init(label: "it.matbuompy.Camera-Control-API")
    let session: AVCaptureSession = .init()
    var cameraPosition: AVCaptureDevice.Position = .back
    var cameraOutput: AVCaptureVideoDataOutput = .init()
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    var permission: CameraPermission = .idle
    
    override init() {
        super.init()
        checkCameraPermission()
    }
    
    /// Checking and asking camera permission
    private func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                permission = .granted
                setupCamera()
            case .notDetermined:
                permission = .idle
                if await AVCaptureDevice.requestAccess(for: .video) {
                    setupCamera()
                }
            case .denied:
                permission = .denied
            case .restricted:
                permission = .denied
            @unknown default:
                break
            }
        }
    }
    
    /// Setting up camera
    private func setupCamera() {
        do {
            session.beginConfiguration()
            
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: cameraPosition).devices.first else {
                print("Could not find back camera")
                session.commitConfiguration()
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input),
                  session.canAddOutput(cameraOutput)
            else {
                print("Could not add camera output")
                session.commitConfiguration()
                return
            }
            
            session.addInput(input)
            session.addOutput(cameraOutput)
            //setupCameraControl(device)
            setupCustomCameraControl(device)
            session.commitConfiguration()
            
            startSession()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startSession() {
        guard !session.isRunning else { return }
        /// Session start/stop must run on a background thread
        Task.detached(priority: .background) {
            await self.session.startRunning()
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        /// Session start/stop must run on a background thread
        Task.detached(priority: .background) {
            await self.session.stopRunning()
        }
    }
    
    private func setupCameraControl(_ device: AVCaptureDevice) {
        /// Check if the device is eligible for CameraControl (only iPhone 16 models)
        guard session.supportsControls else {
            return
        }
        session.setControlsDelegate(self, queue: queue)
        
        /// Removing previously added controls (if any)
        for control in session.controls {
            session.removeControl(control)
        }
        
        /// Defaul Controls
        let zoomControl = AVCaptureSystemZoomSlider(device: device) { zoomProgress in
            print(zoomProgress)
        }
        
        /// Always check whether the control can be added to a session
        if session.canAddControl(zoomControl) {
            session.addControl(zoomControl)
        } else {
            print("Zoom Control can't be added")
        }
    }
    
    private func setupCustomCameraControl(_ device: AVCaptureDevice) {
        /// Check if the device is eligible for CameraControl (only iPhone 16 models)
        guard session.supportsControls else {
            return
        }
        session.setControlsDelegate(self, queue: queue)
        
        /// Removing previously added controls (if any)
        for control in session.controls {
            session.removeControl(control)
        }
        
        /// Custom Controls
        let zoomControl = AVCaptureSlider("Zoom", symbolName: "plus.magnifyingglass", in: -0.5...1)
        zoomControl.setActionQueue(queue) { progress in
            print(progress)
        }
        
        let filters = ["None", "B/W", "Vivid", "Comic", "Humid"]
        let filterControl = AVCaptureIndexPicker("Filters", symbolName: "camera.filters", localizedIndexTitles: filters)
        filterControl.setActionQueue(queue) { index in
            print("Selected Filter: ", filters[index])
        }
        
        let controls: [AVCaptureControl] = [zoomControl, filterControl]
        
        for control in controls {
            if session.canAddControl(control) {
                session.addControl(control)
            } else {
                print("Control \(control.description) cannot be added")
            }
        }
    }
    
    nonisolated func sessionControlsDidBecomeActive(_ session: AVCaptureSession) {
        
    }
    
    nonisolated func sessionControlsWillEnterFullscreenAppearance(_ session: AVCaptureSession) {
        
    }
    
    nonisolated func sessionControlsWillExitFullscreenAppearance(_ session: AVCaptureSession) {
        
    }
    
    nonisolated func sessionControlsDidBecomeInactive(_ session: AVCaptureSession) {
        
    }
    
    func capturePhoto() {
        print("Take Photo")
    }
}

struct CameraView: View {
    
    var camera: Camera = .init()
    @Environment(\.scenePhase) private var scene
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            CameraLayerView(size: size)
        } //: GEOMETRY
        .environment(camera)
        .onChange(of: scene) { oldValue, newValue in
            if newValue == .active {
                camera.startSession()
            } else {
                camera.stopSession()
            }
        }
    }
    
    
}

struct CameraLayerView: UIViewRepresentable {
    
    var size: CGSize
    @Environment(Camera.self) private var camera
    
    func makeUIView(context: Context) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        /// AVCamera Layer
        let layer = AVCaptureVideoPreviewLayer(session: camera.session)
        layer.videoGravity = camera.videoGravity
        layer.frame = frame
        layer.masksToBounds = true
        
        view.layer.addSublayer(layer)
        setupCameraInteraction(view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    private func setupCameraInteraction(_ view: UIView) {
        let cameraControlInteraction = AVCaptureEventInteraction { event in
            if event.phase == .ended {
                /// Camera button is clicked
                camera.capturePhoto()
            }
        }
        view.addInteraction(cameraControlInteraction)
    }
}

#Preview {
    CameraView()
}
