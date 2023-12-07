//
//  ResetPassword.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct ResetPassword: View {
    // MARK: - UI
    @State private var password = ""
    @State private var confirmPassword = ""
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }) //: BACK BUTTON
            .padding(.top, 10)
            
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            VStack(spacing: 25) {
                
                /// Custom TF
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                
                CustomTF(sfIcon: "lock", hint: "Repeat Password", isPassword: true, value: $confirmPassword)
                    .padding(.top, 5)
                
                /// Signup Button
                GradientButton(title: "Continue", icon: "arrow.right") {
                    /// Your Code here
                    dismiss()
                }
                .hSpacing(.trailing)
                /// Disabling until data is entered
                .disableWithOpacity(password.isEmpty || confirmPassword.isEmpty)
                
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
    ResetPassword()
}
