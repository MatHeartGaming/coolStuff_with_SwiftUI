//
//  HackerTextView.swift
//  Hacker Text Effect
//
//  Created by Matteo Buompastore on 20/05/24.
//

import SwiftUI

struct HackerTextView: View {
    
    //MARK: - Properties
    var text: String
    var trigger: Bool
    var transition: ContentTransition = .interpolate
    var duration: CGFloat = 1
    var speed = 0.1
    
    /// UI
    @State private var animatedText: String = ""
    @State private var randomCharacters: [Character] = {
        let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUWVXYZ0123456789-?/#$%@!^%*()="
        return Array(string)
    }()
    @State private var animationID: String = UUID().uuidString
    
    var body: some View {
        Text(animatedText)
            .fontDesign(.monospaced)
            .truncationMode(.tail)
            .contentTransition(transition)
            .animation(.easeInOut(duration: 0.1), value: animatedText)
            .onAppear {
                guard animatedText.isEmpty else { return }
                setRandomCharacters()
                animateText()
            }
            .customOnChange(value: trigger) { newValue in
                animateText()
            }
            .customOnChange(value: text) { newValue in
                animatedText = text
                animationID = UUID().uuidString
                setRandomCharacters()
                animateText()
            }
    }
    
    
    // MARK: - Functions
    
    private func animateText() {
        let currentID = animationID
        for index in text.indices {
            let delay = CGFloat.random(in: 0...duration)
            var timerDuration: CGFloat = 0
            let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                if currentID != animationID {
                    timer.invalidate()
                } else {
                    timerDuration += speed
                    if timerDuration >= delay {
                        if text.indices.contains(index) {
                            let actualCharacter = text[index]
                            replaceCharacter(at: index, character: actualCharacter)
                        }
                    } else {
                        guard let randomCharacter = randomCharacters.randomElement() else { return }
                        replaceCharacter(at: index, character: randomCharacter)
                    }
                }
            }
            timer.fire()
        }
    }
    
    private func setRandomCharacters() {
        animatedText = text
        for index in animatedText.indices {
            guard let randomCharacter = randomCharacters.randomElement() else { return }
            replaceCharacter(at: index, character: randomCharacter)
        }
    }
    
    /// Changes Character at the given index
    private func replaceCharacter(at index: String.Index, character: Character) {
        guard animatedText.indices.contains(index) else { return }
        let indexCharacter = String(animatedText[index])
        if indexCharacter.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            animatedText.replaceSubrange(index...index, with: String(character))
        }
    }
    
}

fileprivate extension View {
    
    @ViewBuilder
    func customOnChange<T: Equatable>(value: T, result: @escaping (T) -> Void) -> some View {
        if #available(iOS 17, *) {
            self
                .onChange(of: value) { oldValue, newValue in
                    result(newValue)
                }
        } else {
            self
                .onChange(of: value) { newValue in
                    result(newValue)
                }
        }
    }
    
}

#Preview {
    ContentView()
}
