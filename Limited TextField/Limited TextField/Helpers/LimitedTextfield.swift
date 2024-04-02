//
//  LimitedTextfield.swift
//  Limited TextField
//
//  Created by Matteo Buompastore on 02/04/24.
//

import SwiftUI

struct LimitedTextfield: View {
    
    //MARK: - Properties
    var config: Config
    var hint: String
    @Binding var value: String
    
    /// UI
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        VStack(alignment: config.progressConfig.alignment, spacing: 12) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .fill(.clear)
                    .frame(height: config.autoResizes ? 0 : nil)
                    .contentShape(.rect(cornerRadius: config.borderConfig.radius))
                    .onTapGesture {
                        /// Show keyboard
                        isKeyboardShowing = true
                    }
                TextField(hint, text: $value, axis: .vertical)
                    .focused($isKeyboardShowing)
                    .onChange(of: value) { oldValue, newValue in
                        guard !config.allowsExcessTyping else { return }
                        value = String(value.prefix(config.limit))
                    }
                    .onChange(of: config.allowsExcessTyping) { oldValue, newValue in
                        if !newValue {
                            value = String(value.prefix(config.limit))
                        }
                    }
                    
            } //: ZSTACK
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .stroke(progressColor.gradient, lineWidth: config.borderConfig.width)
            }
            
            /// ProgressBar / Text Indicator
            HStack(spacing: 12) {
                if config.progressConfig.showsRing {
                    ZStack {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 5)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progressColor.gradient, lineWidth: 5)
                            .rotationEffect(.degrees(-90))
                    } //: ZSTACK
                    .frame(width: 20, height: 20)
                }
                
                if config.progressConfig.showsText {
                    Text("\(value.count)/\(config.limit)")
                        .foregroundStyle(progressColor.gradient)
                }
            }
            
        } //: VSTACK
    }
    
    var progress: CGFloat {
        return max(min(CGFloat(value.count) / CGFloat(config.limit), 1), 0)
    }
    
    var progressColor: Color {
        return progress < 0.6 ? config.tint : (progress == 1) ? .red : .orange
    }
    
    /// Configuration
    struct Config {
        var limit: Int
        var tint: Color = . blue
        var autoResizes: Bool = false
        var allowsExcessTyping: Bool = false
        var progressConfig: ProgressConfig = .init()
        var borderConfig: BorderConfig = .init()
    }
    
    struct ProgressConfig {
        var showsRing: Bool = false
        var showsText: Bool = true
        var alignment: HorizontalAlignment = . trailing
    }
    
    struct BorderConfig {
        var show: Bool = true
        var radius: CGFloat = 12
        var width: CGFloat = 0.8
    }
    
}

#Preview {
    @State var text = ""
    return LimitedTextfield(
        config: .init(
            limit: 40,
            autoResizes: true
        ),
        hint: "Type here",
        value: $text
    )
}

#Preview {
    ContentView()
}
