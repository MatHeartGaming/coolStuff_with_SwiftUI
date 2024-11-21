//
//  ContentView.swift
//  Optional View Modifiers
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

enum Effect: String, CaseIterable {
    case bounce = "Bounce"
    case breathe = "Breathe"
    case pulse = "Pulse"
    case rotate = "Rotate"
}

struct ContentView: View {
        
    @State var effect: Effect = .bounce
    
    var body: some View {
        Group {
            Picker("", selection: $effect) {
                ForEach(Effect.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                        .tag($0)
                }
            } //Picker
            .pickerStyle(.segmented)
            .padding(15)
            
            VStack {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red.gradient)
                    .modifiers { image in
                        switch effect {
                        case .bounce:
                            image.symbolEffect(.bounce)
                        case .breathe:
                            image.symbolEffect(.breathe)
                        case .pulse:
                            image.symbolEffect(.pulse)
                        case .rotate:
                            image.symbolEffect(.rotate)
                        }
                    }
                
                Rectangle()
                    .modifiers { rectangle in
                        switch effect {
                        case .bounce:
                            rectangle.fill(.red.gradient)
                        case .breathe:
                            rectangle.fill(.blue.gradient)
                        case .pulse:
                            rectangle.fill(.green.gradient)
                        case .rotate:
                            rectangle.fill(.yellow.gradient)
                        }
                    }
                    .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    .padding()
            } //: VSTACK
            /*if effect == .bounce {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red.gradient)
                    .symbolEffect(.bounce)
            } else if effect == .breathe {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red.gradient)
                    .symbolEffect(.breathe)
            } else if effect == .pulse {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red.gradient)
                    .symbolEffect(.pulse)
            } else {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red.gradient)
                    .symbolEffect(.rotate)
            }*/
        } //: Group
    }
}

extension View {
    @ViewBuilder
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}

#Preview {
    ContentView()
}
