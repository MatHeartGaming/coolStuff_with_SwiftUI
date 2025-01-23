//
//  ScreenRecorder.swift
//  MacOS Screen Recording App
//
//  Created by Matteo Buompastore on 23/01/25.
//

import SwiftUI
import ScreenCaptureKit

@MainActor
class ScreenRecorder: NSObject, ObservableObject, @preconcurrency SCContentSharingPickerObserver {
    
    override init() {
        super.init()
        setupWindowPicker()
    }
    
    // MARK: View Properties
    @Published var showsCursor: Bool = true
    @Published var capturesAudio: Bool = true
    @Published var backgroundColor: Color = .white
    @Published var videoScale: VideoScale = .normal
    @Published var isRecording: Bool = false
    
    /// Private stuff
    private var contentFilter: SCContentFilter?
    private var stream: SCStream?
    private var streamOutput = StreamOutput()
    
    /// Setting Stream up and recording selected Window
    private func setupAndRecordWindow(_ url: URL) async throws {
        guard let contentFilter else {
            return
        }
        
        let configuration = SCStreamConfiguration()
        configuration.showsCursor = showsCursor
        configuration.capturesAudio = capturesAudio
        
        /// Some SwiftUI colors won't work on ScreenCaptureKit since it works with CGColor
        configuration.backgroundColor = backgroundColor == .white ? CGColor.white : NSColor(backgroundColor).cgColor
        
        let scale = CGFloat(videoScale.rawValue)
        let scaledVideoSize = contentFilter.contentRect.size.applying(.init(scaleX: scale, y: scale))
        configuration.width = Int(scaledVideoSize.width)
        configuration.height = Int(scaledVideoSize.height)
        configuration.scalesToFit = true
        
        let stream = SCStream(filter: contentFilter, configuration: configuration, delegate: streamOutput)
        /// Add separate queue for video and audio
        try stream.addStreamOutput(streamOutput, type: .audio, sampleHandlerQueue: nil)
        try stream.addStreamOutput(streamOutput, type: .screen, sampleHandlerQueue: nil)
        
        /// Saving File
        let outputConfiguration = SCRecordingOutputConfiguration()
        outputConfiguration.outputURL = url
        outputConfiguration.outputFileType = .mov
        
        let output = SCRecordingOutput(configuration: outputConfiguration, delegate: streamOutput)
        try stream.addRecordingOutput(output)
        
        /// Start capture
        try await stream.startCapture()
        self.isRecording = true
        self.stream = stream
        
        streamOutput.finishRecording = {
            /// UI must be updated on Main Thread
            Task {
                self.stream = nil
                self.contentFilter = nil
                self.isRecording = false
            }
        }
    }
    
    func stopWindowRecording() {
        Task {
            do {
                try await stream?.stopCapture()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Asking File Location for the recording to be saved
    private func askFileLocation() {
        Task { @MainActor in
            do {
                let panel = NSOpenPanel()
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.allowsMultipleSelection = false
                panel.showsHiddenFiles = false
                
                let response = panel.runModal()
                if response == .OK {
                    if let fileURL = panel.url?.appending(path: "Recording \(Date()).mov") {
                        print(fileURL)
                        try await setupAndRecordWindow(fileURL)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

/// Setting up the New Window Picker by ScreenCaptureKit
extension ScreenRecorder {
    
    func setupWindowPicker() {
        var pickerConfiguration = SCContentSharingPickerConfiguration()
        pickerConfiguration.allowedPickerModes = .singleWindow
        pickerConfiguration.allowsChangingSelectedContent = false
        
        SCContentSharingPicker.shared.configuration = pickerConfiguration
        SCContentSharingPicker.shared.add(self)
    }
    
    func contentSharingPicker(_ picker: SCContentSharingPicker, didUpdateWith filter: SCContentFilter, for stream: SCStream?) {
        /// This means the window has been selected and we can now close the PickerView and asks where to save the recording
        SCContentSharingPicker.shared.isActive = false
        contentFilter = filter
        askFileLocation()
    }
    
    func contentSharingPicker(_ picker: SCContentSharingPicker, didCancelFor stream: SCStream?) {
        
    }
    
    func contentSharingPickerStartDidFailWithError(_ error: any Error) {
        /// Handle errors
    }
    
}
