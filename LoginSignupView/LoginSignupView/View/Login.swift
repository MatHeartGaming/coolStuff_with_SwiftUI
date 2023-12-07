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
    @State private var showForgotPassword = false
    @State private var showResetView = false
    /// If you want to ask for OTP
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    
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
                    showForgotPassword.toggle()
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.appYellow)
                .hSpacing(.trailing)
                
                /// Login Button
                GradientButton(title: "Login", icon: "arrow.right") {
                    askOTP.toggle()
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
        /// Asking email address for resetting passworrd
        .sheet(isPresented: $showForgotPassword, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted custom sheet corners radius
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        /// Resetting new password
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted custom sheet corners radius
                ResetPassword()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                ResetPassword()
                    .presentationDetents([.height(350)])
            }
        })
        .sheet(isPresented: $askOTP, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted custom sheet corners radius
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
            }
        })
        
    }
}

#Preview {
    Login(showSignup: .constant(true))
}
