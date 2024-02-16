//
//  CustomTextField.swift
//  Walkthrough Intro Page Animation
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI

struct CustomTextField: View {
    
    //MARK: - Properties
    @Binding var text: String
    var hint: String
    var leadingIcon: Image
    var isPassword: Bool = false
    
    var body: some View {
        HStack(spacing: -10) {
            leadingIcon
                .font(.callout)
                .foregroundStyle(.gray)
                .frame(width: 40, height: 40, alignment: .leading)
            
            if isPassword {
                SecureField(hint, text: $text)
            } else {
                TextField(hint, text: $text)
            }
        } //: HSTACK
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.gray.opacity(0.1))
        }
    }
}

#Preview {
    @State var text = ""
    return CustomTextField(text: $text, 
                           hint: "Hint",
                           leadingIcon: Image(systemName: "person.fill"))
}
