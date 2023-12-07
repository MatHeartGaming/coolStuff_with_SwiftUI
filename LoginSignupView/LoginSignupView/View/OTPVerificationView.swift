//
//  OTPView.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct OTPVerificationView: View {
    
    // MARK: - UI
    @Binding var otpText: String
    var otpTextBoxesCount: Int = 6
    
    /// - Keyboard State
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            /// OTP Text Boxes
            ForEach(0..<otpTextBoxesCount, id: \.self) { index in
                OTPTextBox(index)
            }
        } //: HSTACK
        .background(
            TextField("", text: $otpText.limit(otpTextBoxesCount))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                /// Hiding TF
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
        )
        .contentShape(.rect)
        /// Open keyboard on tap
        .onTapGesture {
            isKeyboardShowing.toggle()
        }
        .toolbar{
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing = false
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    
    //MARK: - OTP Text Box
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                /// Finding chart at index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background{
            /// Higlighting Current Active box
            let status = (isKeyboardShowing && index == otpText.count)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? .black : .gray, lineWidth: status ? 1 : 0.5)
                .animation(.easeIn(duration: 0.2), value: status)
        }
        .frame(maxWidth: .infinity)
    }
    
}


// MARK: - EXTENSIONS

/// Binding<String> Extension to limit chars in OTP Boxes
extension Binding where Value == String {
    
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
    
}

#Preview {
    OTPVerificationView(otpText: .constant("123456"))
}
