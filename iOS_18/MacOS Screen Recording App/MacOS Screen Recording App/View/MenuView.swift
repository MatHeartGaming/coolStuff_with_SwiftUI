//
//  MenuView.swift
//  MacOS Screen Recording App
//
//  Created by Matteo Buompastore on 23/01/25.
//

import SwiftUI
import ScreenCaptureKit

struct MenuView: View {
    
    // MARK: Properties
    @StateObject private var screenRecorder: ScreenRecorder = .init()
    @State private var isPermissionGranted: Bool = false
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .white]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            /// Recorder Properties
            VStack(alignment: .leading, spacing: 12) {
                Text("Properties")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.bottom, -6)
                
                Toggle(isOn: $screenRecorder.showsCursor) {
                    Text("Show Cursor")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } //: Toggle Cursor
                
                Toggle(isOn: $screenRecorder.capturesAudio) {
                    Text("Capture Audio")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } //: Toggle Audio
                
                Picker("Background Color", selection: $screenRecorder.backgroundColor) {
                    ForEach(colors, id: \.self) { color in
                        Text(String(describing: color).description)
                            .tag(color)
                    }
                } //: Picker Color
                
                Picker("Video Scale", selection: $screenRecorder.videoScale) {
                    ForEach(VideoScale.allCases, id: \.self) { scale in
                        Text(scale.stringValue)
                            .tag(scale)
                    }
                } //: Picker Scale
                .pickerStyle(.segmented)
            } //: VSTACK
            .toggleStyle(.switch)
            .disabled(screenRecorder.isRecording)
            .opacity(screenRecorder.isRecording ? 0.5 : 1)
            
            /// Window Picker Button
            Button {
                if screenRecorder.isRecording {
                    screenRecorder.stopWindowRecording()
                } else {
                    /// Showing window picker
                    SCContentSharingPicker.shared.isActive = true
                    SCContentSharingPicker.shared.present()
                }
            } label: {
                Text(screenRecorder.isRecording ? "Stop Recording" : "Choose Window")
                    .fontWeight(.semibold)
                    .foregroundStyle(.background)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(Color.primary.gradient, in: .rect(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            } //: Quit App Button
            .buttonStyle(.plain)
            .pointerStyle(.link)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 5)
            .disabled(screenRecorder.isRecording)
            
        } //: VSTACK
        .padding(15)
        .frame(width: 240)
        .overlay {
            if !isPermissionGranted {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Text("No Screen Recording Permission \n\nPlease, grant permission in System Preferences.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primary)
                    }
            }
        }
        .onAppear {
            isPermissionGranted = CGRequestScreenCaptureAccess()
        }
    }
}

#Preview {
    MenuView()
}
