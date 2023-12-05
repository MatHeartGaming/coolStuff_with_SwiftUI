//
//  Home.swift
//  GlassBackgroundEffect
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

struct Home: View {
    
    // MARK: - View Properties
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            // Login View
            VStack(spacing: 12) {
                
                Text("Welcome!")
                    .font(.title.bold())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.callout.bold())
                    
                    CustomTF(hint: "MatBuompy", value: $username)
                    
                    Text("Password")
                        .font(.callout.bold())
                        .padding(.top, 15)
                    
                    CustomTF(hint: "Passsword", value: $password, isPassword: true)
                    
                    Button(action: {}, label: {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.BG)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    })
                    .padding(.top, 30)
                } //: VSTACK Custom TFs
                
                /// Other Login options...
                HStack(spacing: 12) {
                    
                    Button(action: {}, label: {
                        Label("Email", systemImage: "envelope.fill")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            /// Transparent Blur
                            .background(
                                TransparentBlurView(removeAllFilters: false)
                                    .background(.white.opacity(0.2))
                            )
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    }) //: Button Email
                    
                    Button(action: {}, label: {
                        Label("Apple", systemImage: "applelogo")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                TransparentBlurView(removeAllFilters: false)
                                    .background(.white.opacity(0.2))
                            )
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    }) //: Button Apple
                    
                }
                .foregroundStyle(.white)
                .padding(.top, 15)
                
            } //: Vstack Login
            .foregroundStyle(.white)
            .padding(.horizontal, 30)
            .padding(.top, 35)
            .padding(.bottom, 25)
            .background(
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            )
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
            /// Light white border
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.3), lineWidth: 1.5)
            )
            /// Shadows
            .shadow(color: .black.opacity(0.2), radius: 10)
            .padding(.horizontal, 30)
            .background {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color("Gradient1"), Color("Gradient2")], startPoint: .top, endPoint: .bottom))
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .offset(x: -25, y: -55)
                    
                    Circle()
                        .fill(LinearGradient(colors: [Color("Gradient3"), Color("Gradient4")], startPoint: .top, endPoint: .bottom))
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: 25, y: 55)
                }
            }
        } //: VSTACK
        .frame(maxWidth: 390)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Rectangle()
                .fill(.BG)
                .ignoresSafeArea()
        )
    }
    
    
    //MARK: - Custom TextField
    @ViewBuilder
    func CustomTF(hint: String, value: Binding<String>, isPassword: Bool = false) -> some View {
        Group {
            if isPassword {
                SecureField(hint, text: value)
            } else {
                TextField(hint, text: value)
            }
        } //: GROUP
        .environment(\.colorScheme, .dark)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(.white.opacity(0.12))
        .clipShape(.rect(cornerRadius: 8, style: .continuous))
        
    }
    
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
