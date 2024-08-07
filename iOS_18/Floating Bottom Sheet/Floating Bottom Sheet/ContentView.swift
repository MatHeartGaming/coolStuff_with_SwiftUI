//
//  ContentView.swift
//  Floating Bottom Sheet
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Show Sheet") {
                    showSheet.toggle()
                }
            } //: VSTACK
            .navigationTitle("Floating Bottom Sheet")
        } //: NAVIGATION
        .floatingBottomSheet(isPresented: $showSheet) {
            SheetView(
                title: "Replace existing folder?",
                content: "Lorem ipsum is simply dummy text",
                image: .init(
                    content: "questionmark.folder.fill",
                    tint: .blue,
                    foregorund: .white
                ),
                button1: .init(
                    content: "Replace",
                    tint: .blue,
                    foregorund: .white
                ),
                button2: .init(
                    content: "Cancel",
                    tint: Color.primary.opacity(
                        0.08
                    ),
                    foregorund: Color.primary
                )
            )
            /*Text("Hello Sheet!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background.shadow(.drop(radius: 5)), in: .rect(cornerRadius: 25))
                .padding(.horizontal, 15)
                .padding(.top, 15)*/
            /// DO NOT use .large presentation detent, instead, use 0.999 to avoid source view shrinking
            /// and therefore the weird shadowing effect on the background
            .presentationDetents([.height(100), .height(330), .fraction(0.999)])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(330)))
        }
    }
}

/// Sample View
struct SheetView: View {
    
    var title: String
    var content: String
    var image: Config
    var button1: Config
    var button2: Config?
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: image.content)
                .font(.title)
                .foregroundStyle(image.foregorund)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
            
            Text(title)
                .font(.title3.bold())
            
            Text(content)
                .font(.callout)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.gray)
            
            ButtonView(button1)
            
            if let button2 {
                ButtonView(button2)
            }
            
        } //: VSTACK
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private func ButtonView(_ config: Config) -> some View {
        Button {
            
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foregorund)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10, style: .continuous))
        }

    }
    
    struct Config {
        var content: String
        var tint: Color
        var foregorund: Color
    }
}

#Preview {
    ContentView()
}
