//
//  ForgotPassword.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct ForgotPassword: View {
    
    // MARK: - UI
    @Binding var showResetView: Bool
    @State private var emailID = ""
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
            .padding(.top, 10)
            
            Text("Forgot Password?")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please enter your email address so that we can send you a link to reset your password.")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                
                /// Custom TF
                CustomTF(sfIcon: "at", hint: "Email", value: $emailID)
                
                /// Signup Button
                GradientButton(title: "Continue", icon: "arrow.right") {
                    /// Code after link is sent
                    
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        showResetView = true
                    }
                    
                }
                .hSpacing(.trailing)
                /// Disabling until data is entered
                .disableWithOpacity(emailID.isEmpty)
                
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
    ForgotPassword(showResetView: .constant(false))
}
