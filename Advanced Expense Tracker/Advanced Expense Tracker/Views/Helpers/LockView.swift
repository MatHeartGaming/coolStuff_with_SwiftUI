//
//  LockView.swift
//  Padlock
//
//  Created by Matteo Buompastore on 30/11/23.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    
    // MARK: - LOCK PROPERTIES
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground = true
    @ViewBuilder var content: Content
    //var forgotPin: () -> Void = {  }
    
    
    // MARK: - VIEW PROPERTIES
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.scenePhase) private var scene
    @State private var pin: String = ""
    @State private var animateField = false
    @State private var isUnlocked = false
    @State private var noBiometricAccess = false
    
    let context = LAContext()
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var rectangleColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                
                ZStack {
                    
                    Rectangle()
                        .fill(rectangleColor)
                        .ignoresSafeArea()
                    
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Enable biometric authentication in Settings to unlock the view.")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                                    .foregroundStyle(textColor)
                                
                            } else {
                                // Biometric / Pin
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        /// Custom Number Pad to type Pin
                        NumberPadPinView()
                    }
                } //: ZSTACK
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: scene, { oldValue, newValue in
            switch (newValue, lockWhenAppGoesBackground) {
            case (.background, true):
                isUnlocked = false
                pin = ""
            case (.inactive, _ ): break
            case (.active, _ ):
                break
            case (.background, false):
                isUnlocked = true
            @unknown default:
                isUnlocked = false
                pin = ""
            }
        })
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
    }
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func unlockView() {
        Task {
            if isBiometricAvailable {
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the view"), result {
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            
            // No biometric permission or lock type is set as numpad
            // Updating biometric status
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 15) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if lockType == .both && isBiometricAvailable {
                        Button {
                            pin = ""
                            noBiometricAccess = false
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        }
                        .tint(textColor)
                        .padding(.leading)
                    }
                }
            
            /// Adding shake animation on wrong password using key frame
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                        /// Showing Pin at each cell using index
                        .overlay{
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                            }
                        }
                }
            } //: HSTACK
            .keyframeAnimator(initialValue: .zero, trigger: animateField, content: { content, value in
                content
                    .offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .padding(.top, 15)
            .overlay(alignment: .bottomTrailing, content: {
                Button("Forgot your PIN?") {
                    //forgotPin()
                }
                .font(.caption)
                .foregroundStyle(.background.opacity(0.7))
                .offset(y: 40)
            })
            .frame(maxHeight: .infinity)
            
            
            /// Num Pad
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            /// Adding number to pin
                            guard pin.count < 4 else { return }
                            pin.append("\(number)")
                            
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        }) //: NUMBER BUTTON
                    } //: LOOP
                    
                    Button(action: {
                        guard !pin.isEmpty else { return }
                        pin.removeLast()
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }) //: BACK BUTTON
                    
                    Button(action: {
                        /// Adding number to pin
                        guard pin.count < 4 else { return }
                        pin.append("0")
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }) //: ZERO BUTTON
                    
                }) //: GRID
                .frame(maxHeight: .infinity, alignment: .bottom)
            } //: GEOMETRY
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4{
                    /// Validate pin
                    if lockPin == pin {
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        print("Wrong pin")
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
            
        }
        .padding()
        .foregroundStyle(.background)
    }
    
    enum LockType: String {
        case biometric = "Biometric Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric, and if it's not available, it will fallback to number lock."
    }
    
}

#Preview {
    LockView(lockType: .biometric, lockPin: "1234", isEnabled: true, content: {
        Text("Hellooo!!")
    })
}
