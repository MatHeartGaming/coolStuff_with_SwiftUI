//
//  ContentView.swift
//  Alert Dialogs
//
//  Created by Matteo Buompastore on 18/09/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var showPopup: Bool = false
    @State private var showAlert: Bool = false
    @State private var isWrongPassword: Bool = false
    @State private var isTryingAgain: Bool = false
    
    var body: some View {
        NavigationStack {
            Button("Unlock Files") {
                showPopup.toggle()
            }
            .navigationTitle("Documents")
        } //: NAVIGATION
        .popView(isPresented: $showPopup) {
            showAlert = isWrongPassword
            isWrongPassword = false
        } content: {
            CustomAlertWithTextField(show: $showPopup) { password in
                isWrongPassword = password != "MatB"
            }
        }
        .popView(isPresented: $showAlert) {
            showPopup = isTryingAgain
        } content: {
            CustomAlert(show: $showAlert) {
                showPopup = true
            }
        }


        
    }
}

struct CustomAlertWithTextField: View {
    
    /// View Properties
    @Binding var show: Bool
    var onUnlock: (String) -> Void
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.key.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.blue.gradient)
                        .background {
                            Circle()
                                .fill(.background)
                                .padding(-5)
                        }
                }
            
            Text("Locked File")
                .fontWeight(.semibold)
            
            Text("This file has been locked by the user, please enter the password to continue")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            SecureField("Password", text: $password)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.bar)
                }
                .padding(.vertical, 10)
            
            HStack {
                Button {
                    show = false
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                } //: Button Cancel
                
                Button {
                    show = false
                    onUnlock(password)
                } label: {
                    Text("Unlock")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                } //: Button Unlock

            } //: HSTACK
            
        } //: VSTACK
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .padding(.top, 25)
        }
    }
    
}

struct CustomAlert: View {
    
    /// View Properties
    @Binding var show: Bool
    var onTryAgain: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.key.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.red.gradient)
                        .background {
                            Circle()
                                .fill(.background)
                                .padding(-5)
                        }
                }
            
            Text("Wrong Password")
                .fontWeight(.semibold)
            
            Text("Enter the correct password")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            HStack {
                Button {
                    show = false
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                } //: Button Cancel
                
                Button {
                    show = false
                    onTryAgain()
                } label: {
                    Text("Try Again")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                } //: Button Unlock

            } //: HSTACK
            
        } //: VSTACK
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .padding(.top, 25)
        }
    }
    
}

#Preview {
    ContentView()
}
