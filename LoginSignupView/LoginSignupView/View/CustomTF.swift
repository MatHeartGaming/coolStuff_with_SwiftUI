//
//  CustomTF.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct CustomTF: View {
    
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    
    /// For SecureTF
    var isPassword: Bool = false
    @Binding var value: String
    
    @State private var showPassword = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                
                if isPassword {
                    Group {
                        /// Revealing password
                        if showPassword {
                            TextField(hint, text: $value)
                        } else {
                            SecureField(hint, text: $value)
                        }
                    } //: GROUP
                    
                } else {
                    TextField(hint, text: $value)
                }
                
                Divider()
                
            } //: VSTACK
            .overlay(alignment: .trailing) {
                /// Password reveal button
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(iconTint)
                            .padding(10)
                            .contentShape(.rect)
                    }) //: BUTTON SHOW/HIDE PASSWORD
                }
            }
            
        } //: HSTACK
    }
    
}

#Preview {
    CustomTF(sfIcon: "person", hint: "Scrivi", value: .constant(""))
}
