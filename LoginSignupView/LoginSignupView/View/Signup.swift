//
//  Signup.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct Signup: View {
    
    // MARK: - UI
    @Binding var showSignup: Bool
    @State private var emailID = ""
    @State private var fullName = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            /// Back Button
            Button(action: {
                showSignup = false
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }) //: BACK BUTTON
            .padding(.top, 10)
            
            Text("Signup")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please sign up in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                
                /// Custom TF
                CustomTF(sfIcon: "at", hint: "Email", value: $emailID)
                
                CustomTF(sfIcon: "person", hint: "Full Name", value: $fullName)
                    .padding(.top, 5)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                /// Signup Button
                GradientButton(title: "Continue", icon: "arrow.right") {
                    
                }
                .hSpacing(.trailing)
                /// Disabling until data is entered
                .disableWithOpacity(emailID.isEmpty || password.isEmpty || fullName.isEmpty)
                
            } //: VSTACK
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                
                Text("Already have an account?")
                    .foregroundStyle(.gray)
                
                Button("Login") {
                    showSignup = false
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
    Signup(showSignup: .constant(true))
}
