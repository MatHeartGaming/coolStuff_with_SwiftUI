//
//  ContentView.swift
//  Alternate App Icons
//
//  Created by Matteo Buompastore on 04/10/24.
//

import SwiftUI

enum AppIcon: String, CaseIterable {
    case appIcon = "Default"
    case appIcon2 = "AppIcon1"
    case appIcon3 = "AppIcon2"
    
    var iconValue: String? {
        if self == .appIcon {
            return nil
        } else {
            return rawValue
        }
    }
    
    var previewImage: String {
        switch self {
            case .appIcon: "Logo 1"
            case .appIcon2: "Logo 2"
            case .appIcon3: "Logo 3"
        }
    }
}

struct ContentView: View {
    
    @State private var currentAppIcon: AppIcon = .appIcon
    
    var body: some View {
        NavigationStack {
            List {
                Section("Choose App Icon") {
                    ForEach(AppIcon.allCases, id: \.rawValue) { icon in
                        HStack(spacing: 15) {
                            Image(icon.previewImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(.rect(cornerRadius: 10))
                            
                            Text(icon.rawValue)
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: currentAppIcon == icon ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(currentAppIcon == icon ? .green : Color.primary)
                            
                        } //: HSTACK
                        .contentShape(.rect)
                        .onTapGesture {
                            currentAppIcon = icon
                            UIApplication.shared.setAlternateIconName(icon.iconValue)
                        }
                    } //: Loop Icons
                } //: SECTION
            } //: LIST
            .navigationTitle("App Icons")
        } //: NAVIGATION
        .onAppear {
            if let alternativeAppIcon = UIApplication.shared.alternateIconName, let appIcon = AppIcon.allCases.first(where: { $0.rawValue == alternativeAppIcon }) {
                currentAppIcon = appIcon
            } else {
                currentAppIcon = .appIcon
            }
        }
    }
}

#Preview {
    ContentView()
}
