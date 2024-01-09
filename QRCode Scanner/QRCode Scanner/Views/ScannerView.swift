//
//  ScannerView.swift
//  QRCode Scanner
//
//  Created by Matteo Buompastore on 09/01/24.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    
    // MARK: - UI
    @State private var isScanning = false
    @State private var session = AVCaptureSession()
    @State private var cameraPermission: Permission = .idle
    @State private var showAlertQRScanned = false
    
    /// QR Scanner output
    @State private var qrOutput = AVCaptureMetadataOutput()
    
    /// Error Properties
    @State private var errorMessage = ""
    @State private var showError = false
    @Environment(\.openURL) private var openURL
    
    /// Camera QR Output Delegate
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    /// Scanner Code
    @State private var scannedCode = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {}, label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundStyle(.qrScanner)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Place the QR Code inside the area")
                .font(.title3)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundStyle(.gray)
            
            Spacer(minLength: 0)
            
            /// Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                        .scaleEffect(0.97)
                    
                    ForEach(0...4, id: \.self) {index in
                        let roation = Double(index) * 90
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                        /// Trimming to get scanner like Edges
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.qrScanner, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(roation))
                    }
                    
                }
                /// Square shape
                .frame(width: size.width, height: size.width)
                /// Scanner animation
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.qrScanner)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                }
                /// To Center it
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } //: GEOMETRY CAMERA
            .padding(.horizontal, 45)
            
            Spacer(minLength: 0)
            
            Button(action: {
                restartScanning()
            }, label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                
            })
            
            Spacer(minLength: 45)
            
        } //: VSTACK
        .padding(15)
        /// Chacking camera permission when camera is visible
        .onAppear(perform: checkCameraPermssion)
        .alert(errorMessage, isPresented: $showError) {
            /// Showing settings button if permission is denied
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        /// Opening app's settings using openURL SwiftUI
                        openURL(settingsURL)
                    }
                }
                
                /// Cancel button
                Button("Cancel", role: .cancel) {}
            }
        } //: ALERT ERROR
        .alert("QR Code Scanned: \(scannedCode)", isPresented: $showAlertQRScanned, actions: {
            Button("OK", role: .cancel) {}
        })
        .onChange(of: qrDelegate.scannedCode) { newValue in
            if let code = newValue {
                scannedCode = code
                showAlertQRScanned.toggle()
                /// When the first result arrives we can stop the camera
                session.stopRunning()
                deactivateScannerAnimation()
                
                /// Clear data in the Delegate
                qrDelegate.scannedCode = nil
            }
        }
        .onDisappear {
            session.stopRunning()
        }
    }
    
    //MARK: - View
    private func activateScannerAnimation() {
        withAnimation(.easeIn(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    private func deactivateScannerAnimation() {
        withAnimation(.easeIn(duration: 0.85)) {
            isScanning = false
        }
    }
    
    
    //MARK: - Functions
    
    func restartScanning() {
        guard !session.isRunning && cameraPermission == .approved else { return }
        
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
            activateScannerAnimation()
        }
    }
    
    /// Setup Camera
    private func setupCamera() {
        do {
            /// Looking for rear camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("CAMERA NOT FOUND.")
                return
            }
            
            /// Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            /// For extra safety: Check whether input and output can be added to the session
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("Unkown input/output Error")
                return
            }
            
            /// Adding Input and output to camera session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            /// Setting Output config to read QR Codes
            qrOutput.metadataObjectTypes = [.qr]
            
            /// Adding Delegate to retrieve the fetched QR from camera
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            /// Session must be started on a Background Thread
            restartScanning()
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    /// Camera Permissions
    private func checkCameraPermssion() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                
            case .notDetermined:
                /// Request it
                if await AVCaptureDevice.requestAccess(for: .video) {
                    /// Granted
                    cameraPermission = .approved
                    if session.inputs.isEmpty {
                        /// New setup needed
                        setupCamera()
                    } else {
                        /// Already setupped
                        restartScanning()
                    }
                    
                } else {
                    cameraPermission = .denied
                    /// Presenting error message
                    presentError("Please, provide access to Camera for scanning QR Codes.")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please, provide access to Camera for scanning QR Codes.")
            case .authorized:
                cameraPermission = .approved
                setupCamera()
            @unknown default:
                break
            }
        }
    }
    
    private func presentError(_ error: String)  {
        errorMessage = error
        showError.toggle()
    }
    
}

#Preview {
    ScannerView()
}
