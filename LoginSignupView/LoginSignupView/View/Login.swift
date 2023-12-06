//
//  Login.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct Login: View {
    
    // MARK: - UI
    @Binding var showSignup: Bool
    @State private var emailID = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: 0)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                
                /// Custom TF
                CustomTF(sfIcon: "at", hint: "Email", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("Forgot Password") {
                    
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.appYellow)
                .hSpacing(.trailing)
                
                /// Login Button
                GradientButton(title: "Login", icon: "arrow.right") {
                    
                }
                .hSpacing(.trailing)
                /// Disabling until data is entered
                .disableWithOpacity(emailID.isEmpty || password.isEmpty)
                
            } //: VSTACK
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                
                Button("Sign up") {
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .tint(.appYellow)
                
            } //: HSTACK
            .font(.callout)
            .hSpacing()
            
        } //: VSTACK
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    Login(showSignup: .constant(true))
}
