//
//  ContentView.swift
//  New macOS 15 API Floating Window
//
//  Created by Matteo Buompastore on 16/01/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack(spacing: 10) {
            Button("Show Floating Window") {
                openWindow(id: "FloatingWindow")
            }
            Button("Show Alert Window") {
                openWindow(id: "AlertWindow")
            }
        }
    }
}

struct FloatingWindow: View {
    
    @State private var isHovering: Bool = false
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        Image(.pic)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
            .clipShape(.rect(cornerRadius: 30))
            .overlay {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Button {
                            dismissWindow()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)

                    }
                    .opacity(isHovering ? 1 : 0)
                    .animation(.snappy, value: isHovering)
            }
            .onHover { isHovering in
                self.isHovering = isHovering
            }
            .clipShape(.rect(cornerRadius: 30))
    }
    
}

struct AlertWindow: View {
    
    @State private var showAlert: Bool = false
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
            
            VStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary.secondary)
                Text("Saved Successfully")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            } //: VSTAK
        } //: ZSTAK
        .frame(width: 200, height: 200)
        .opacity(showAlert ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.25)) {
                showAlert = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.25), completionCriteria: .logicallyComplete) {
                    showAlert = false
                } completion: {
                    dismissWindow()
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
