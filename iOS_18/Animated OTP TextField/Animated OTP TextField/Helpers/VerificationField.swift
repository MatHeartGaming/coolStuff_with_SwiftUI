//
//  VerificationField.swift
//  Animated OTP TextField
//
//  Created by Matteo Buompastore on 30/01/25.
//

import SwiftUI

/// Properties
enum CodeType: Int, CaseIterable {
    
    case four = 4
    case six = 6
    
    var stringValue: String {
        "\(rawValue) Digit"
    }
    
}

enum TypingState {
    case typing
    case valid
    case invalid
}

enum TextFieldStyle: String, CaseIterable {
    case roundedBorder = "Rounded Border"
    case underlined = "Underlined"
}

struct VerificationField: View {
    
    // MARK: Properties
    var type: CodeType
    var style: TextFieldStyle = .roundedBorder
    @Binding var value: String
    
    /// To validate the typed code!!
    var onChange: (String) async -> TypingState
    
    /// UI
    @State private var state: TypingState = .typing
    @State private var invalidTrigger: Bool = false
    @FocusState private var isActive: Bool
    
    var body: some View {
        HStack(spacing: style == .roundedBorder ? 6 : 10) {
            ForEach(0..<type.rawValue, id: \.self) { index in
                CharacterView(index)
            } //: Loop Characters
        } //: HSTACK
        .background {
            TextField("", text: $value)
                .focused($isActive)
                .keyboardType(.numberPad)
                /// Enable automatic OTP detection
                .textContentType(.oneTimeCode)
                .mask(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                }
                .allowsHitTesting(false)
        }
        .animation(.easeInOut(duration: 0.2), value: value)
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .compositingGroup()
        /// Invalid OTP Phase Animator
        .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: invalidTrigger, content: { content, offset in
            content
                .offset(x: offset)
        }, animation: { _ in
                .linear(duration: 0.06)
        })
        .contentShape(.rect)
        .onTapGesture {
            isActive = true
        }
        .onChange(of: value) { oldValue, newValue in
            /// Limting text length
            value = String(newValue.prefix(type.rawValue))
            Task { @MainActor in
                state = await onChange(value)
                if state == .invalid {
                    invalidTrigger.toggle()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isActive = false
                }
                .tint(Color.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func CharacterView(_ index : Int) -> some View {
        Group {
            if style == .roundedBorder {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(index), lineWidth: 1.2)
            } else {
                Rectangle()
                    .fill(borderColor(index))
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        } //: Group
        .frame(width: style == .roundedBorder ? 50 : 40, height: 50)
        .overlay {
            /// Character
            let stringValue = self.string(index)
            
            if !stringValue.isEmpty {
                Text(stringValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .transition(.blurReplace)
            }
        }
    }
    
    
    // MARK: Functions
    
    func borderColor(_ index: Int) -> Color {
        switch state {
            /// Let's Highlight active field when the keyboard is active
        case .typing: value.count == index && isActive ? Color.primary : .gray
            case .valid: .green
            case .invalid: .red
        }
    }
    
    func string(_ index: Int) -> String {
        if value.count > index {
            let startingIndex = value.startIndex
            let stringIndex = value.index(startingIndex, offsetBy: index)
            
            return String(value[stringIndex])
        }
        return ""
    }
    
}

#Preview {
    ContentView()
}
