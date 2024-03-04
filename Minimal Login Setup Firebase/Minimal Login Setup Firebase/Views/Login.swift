//
//  Login.swift
//  Minimal Login Setup Firebase
//
//  Created by Matteo Buompastore on 04/03/24.
//

import SwiftUI
import Firebase
import Lottie

struct Login: View {
    
    //MARK: - Properties
    @State private var activeTab: Tab = .login
    @State private var isLoading: Bool = false
    @State private var showEmailVerificationView: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    
    /// Alert
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    /// Forgot Password
    @State private var showResetAlert: Bool = false
    @State private var resetEmailAddress: String = ""
    
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Email Address", text: $emailAddress)
                        .keyboardType(.emailAddress)
                        .customTextField("person")
                    SecureField("Password", text: $password)
                        .customTextField("lock", paddingTop: 0, paddingBottom: activeTab == .login ? 10 : 0)
                    if activeTab == .signUp {
                        SecureField("Repeat Password", text: $reEnterPassword)
                            .customTextField("lock", paddingTop: 0, paddingBottom: activeTab != .login ? 10 : 0)
                    }
                } header: {
                    Picker("", selection: $activeTab) {
                        ForEach(Tab.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                        } //: Loop Tabs
                    } //: Picker Tab
                    .pickerStyle(.segmented)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .listRowSeparator(.hidden)
                } footer: {
                    VStack(alignment: .trailing, spacing: 12) {
                        if activeTab == .login {
                            Button("Forgot Password?") {
                                showResetAlert = true
                            }
                            .font(.caption)
                            .tint(.accentColor)
                        }
                        
                        Button(action: loginAndSignup, label: {
                            HStack(spacing: 12) {
                                Text(activeTab == .login ? "Login" : "Create an Account")
                                Image(systemName: "arrow.right")
                                    .font(.callout)
                            } //: HSTACK
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .showLoadingIndicator(isLoading)
                        .disabled(buttonStatus)
                    } //: VSTACK
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
                } //: SECTION
                .disabled(isLoading)
                
            } //: LIST
            .animation(.snappy, value: activeTab)
            .listStyle(.insetGrouped)
            .navigationTitle(activeTab == .login ? "Welcome Back!" : "Create Account")
        } // : NAVIGATION
        .sheet(isPresented: $showEmailVerificationView, content: {
            EmailVerificationView()
                .presentationDetents([.height(350)])
                .presentationCornerRadius(25)
                .interactiveDismissDisabled()
        })
        .onChange(of: activeTab) { oldValue, newValue in
            password = ""
            reEnterPassword = ""
        }
        .alert(alertMessage, isPresented: $showAlert) {}
        .alert("Reset Password", isPresented: $showResetAlert, actions: {
            TextField("Email Address", text: $resetEmailAddress)
            Button("Send Reset Link", role: .destructive, action: sendResetLink)
            Button("Cancel", role: .cancel) {
                resetEmailAddress = ""
            }
        }, message: {
            Text("Enter the Email Address")
        })
    }
    
    
    //MARK: - Functions
    
    func sendResetLink() {
        Task {
            do {
                if resetEmailAddress.isEmpty {
                    await presentAlert("Please, enter the email address.")
                    return
                }
                isLoading = true
                try await Auth.auth().sendPasswordReset(withEmail: resetEmailAddress)
                await presentAlert("Please, check your email inbox and follow the steps to reset your password.")
                resetEmailAddress = ""
                isLoading = false
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    private func loginAndSignup() {
        Task {
            isLoading = true
            do {
                if activeTab == .login {
                    let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                    if result.user.isEmailVerified {
                        /// User is verified
                        /// Redirect to HomeView
                        logStatus = true
                    } else {
                        /// User NOT Verified. Send verification Email...
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }
                } else {
                    /// Creating New Account
                    if password == reEnterPassword {
                        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    } else {
                        await presentAlert("Mismatching Passwords!")
                    }
                }
            } catch(let error) {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    private func presentAlert(_ message: String) async {
        await MainActor.run {
            alertMessage = message
            showAlert = true
            isLoading = false
            resetEmailAddress = ""
        }
    }
    
    
    /// Tab Type
    private enum Tab: String, CaseIterable {
        case login = "Login"
        case signUp = "Sign Up"
    }
    
    /// Button Status
    private var buttonStatus: Bool {
        if activeTab == .login {
            return emailAddress.isEmpty || password.isEmpty
        }
        return emailAddress.isEmpty || password.isEmpty || reEnterPassword.isEmpty
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func EmailVerificationView() -> some View {
        VStack(spacing: 6) {
            GeometryReader { proxy in
                if let bundle = Bundle.main.path(forResource: "EmailAnimation", ofType: "json") {
                    LottieView {
                        await LottieAnimation.loadedFrom(url: URL(filePath: bundle))
                    }
                    .playing(loopMode: .loop)
                }
            } //: GEOMETRY
            
            Text("Verification")
                .font(.title.bold())
            
            Text("We have sent a verification email to your email address: \(emailAddress).\nPlease verify to continue.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 25)
            
        } //: VSTACK
        .overlay(alignment: .topTrailing) {
            Button("Cancel") {
                showEmailVerificationView = false
                isLoading = false
                /// Optionally delete the User Account
                if let user = Auth.auth().currentUser {
                    user.delete { error in
                        guard let error else { return }
                        Task {
                            await presentAlert(error.localizedDescription)
                        }
                    }
                }
            }
            .padding(15)
        }
        .padding(.bottom, 15)
        .onReceive(Timer.publish(every: 2, on: .main, in: .default).autoconnect(), perform: { _ in
            if let user = Auth.auth().currentUser {
                user.reload()
                if user.isEmailVerified {
                    showEmailVerificationView = false
                    isLoading = false
                    logStatus = true
                }
            }
        })
    }
    
}

fileprivate extension View {
    
    @ViewBuilder
    func showLoadingIndicator(_ status: Bool) -> some View {
        self
            .animation(.snappy) { content in
                content
                    .opacity(status ? 0 : 1)
            }
            .overlay {
                if status {
                    ZStack {
                        Capsule()
                            .fill(.bar)
                        
                        ProgressView()
                    } //: ZSTACK
                }
            }
    }
    
    @ViewBuilder
    func customTextField(_ icon: String? = nil, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0) -> some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.gray)
            }
            
            self
            
        } //: HSTACK
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 15)
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
    }
    
}


//MARK: - Previews

#Preview {
    Login()
}

#Preview {
    ContentView()
}
