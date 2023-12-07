//
//  OTPView.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct OTPView: View {
    // MARK: - UI
    @Binding var otpText: String
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }) //: BACK BUTTON
            .padding(.top, 15)
            
            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("A 6 digit code has been sent to your Email Address.")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                
                /// Custom OTP TextField
                OTPVerificationView(otpText: $otpText)
                
                
                /// Signup Button
                GradientButton(title: "Continue", icon: "arrow.right") {
                    /// Code after link is sent
                    dismiss()
                }
                .hSpacing(.trailing)
                /// Disabling until data is entered
                .disableWithOpacity(otpText.count < 6)
                
            } //: VSTACK
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
        } //: VSTACK
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        /// Since this is going to be a Sheet
        .interactiveDismissDisabled()
    }
}

#Preview {
    OTPView(otpText: .constant("123456"))
}
