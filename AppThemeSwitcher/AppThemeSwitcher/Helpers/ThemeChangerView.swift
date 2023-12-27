//
//  ThemeChangerView.swift
//  AppThemeSwitcher
//
//  Created by Matteo Buompastore on 27/12/23.
//

import SwiftUI

struct ThemeChangerView: View {
    
    // MARK: - UI
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    /// For Sliding effect
    @Namespace private var animation
    
    @State private var circleOffset: CGSize
    
    init(scheme: ColorScheme) {
        self.scheme = scheme
        let isDark = scheme == .dark
        self._circleOffset = .init(initialValue: CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Circle()
                .fill(userTheme.color(scheme).gradient)
                .frame(width: 150, height: 150)
                .mask {
                    /// Inverted mask
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(circleOffset)
                                .blendMode(.destinationOut)
                        }
                }
            
            Text("Choose a Style")
                .multilineTextAlignment(.center)
                .font(.title2.bold())
                .padding(.top, 25)
            
            Text("Pop or subtle, Day or Night. \nCustomise your interface.")
                .multilineTextAlignment(.center)
            
            /// Custom Segented Picker
            HStack(spacing: 0) {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .background {
                            ZStack(alignment: .leading) {
                                if (userTheme == theme) {
                                    Capsule()
                                        .fill(.themeBG.gradient)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                    
                                    Image(systemName: theme.icon)
                                        .mask {
                                            Capsule()
                                                .fill(.themeBG.gradient)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        }
                                    
                                }
                            } //: ZSTACK
                            .animation(.snappy, value: userTheme)
                            .frame(width: 100)
                            
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                        .animation(.snappy, value: userTheme)
                } //: HSTACK
                .frame(width: 100)
                
            } //: LOOP THEME
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
            .padding(.top, 20)
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(.themeBG)
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, scheme)
        .onChange(of: scheme, initial: false) { _, newValue in
            let isDark = newValue == .dark
            withAnimation(.bouncy) {
                circleOffset = CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150)
            }
        }
    }
}

enum Theme: String, CaseIterable {
    
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return scheme == .dark ? .moon : .sun
        case .light:
            return .sun
        case .dark:
            return .moon
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var icon: String {
        switch self {
            
        case .systemDefault:
            return "sun.max.circle"
        case .light:
            return "sun.min"
        case .dark:
            return "moonphase.waxing.gibbous"
        }
    }
    
}

#Preview {
    ThemeChangerView(scheme: .light)
}
