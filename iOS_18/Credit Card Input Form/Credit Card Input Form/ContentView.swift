//
//  ContentView.swift
//  Credit Card Input Form
//
//  Created by Matteo Buompastore on 27/01/25.
//

import SwiftUI

/// Card Model
struct Card: Hashable {
    var name: String = ""
    var number: String = ""
    var cvv: String = ""
    var month: String = ""
    var year: String = ""
    
    var rawCardNumber: String {
        number.replacingOccurrences(of: " ", with: "")
    }
}

/// Active TF
enum ActiveField {
    case none
    case name
    case number
    case cvv
    case month
    case year
    
}

struct ContentView: View {
    
    @State private var card: Card = .init()
    @FocusState private var activeField: ActiveField?
    
    /// For some reason the FocusState is not animating properly. Not only that,
    /// also the Matched Geometry Effect does not work
    @State private var animateField: ActiveField?
    
    /// Final FX (Highlightting active field in the card with Matched Geometry)
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            
            /// Card View
            ZStack {
                if animateField != .cvv {
                    MeshGradient(width: 3, height: 3, points: [
                        .init(0, 0), .init(0.5, 0),.init(1, 0),
                        .init(0, 0.5), .init(0.9, 0.6),.init(1, 0.5),
                        .init(0, 1), .init(0.5, 1),.init(1, 1),
                    ], colors: [
                        .red, .red, .pink,
                        .pink, .orange, .red,
                        .red, .orange, .red
                    ])
                    .clipShape(.rect(cornerRadius: 25))
                    .overlay {
                        CardFrontView()
                    }
                    .transition(.flip)
                } else {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red.mix(with: .blue, by: 0.2))
                        .overlay {
                            CardBackView()
                        }
                        .frame(height: 200)
                        .transition(.reverseFlip)
                }
            } //: ZSTACK
            .frame(height: 200)
            //.animation(.snappy, value: activeField)
            
            CustomTextField(title: "Card Number", hint: "", value: $card.number) {
                /// Limiting to 16 digits and adding space every 4 digits
                card.number = String(card.number.group(" ", count: 3).prefix(19))
            }
            .keyboardType(.numberPad)
            .focused($activeField, equals: .number)
            
            CustomTextField(title: "Card Name", hint: "", value: $card.name) {
                
            }
            .focused($activeField, equals: .name)
            
            HStack(spacing: 10) {
                CustomTextField(title: "Month", hint: "", value: $card.month) {
                    card.month = String(card.month.prefix(2))
                    
                    if card.month.count == 2 {
                        activeField = .year
                    }
                }
                .focused($activeField, equals: .month)
                
                CustomTextField(title: "year", hint: "", value: $card.year) {
                    card.year = String(card.year.prefix(2))
                    if card.year.count == 2 {
                        activeField = .cvv
                    }
                }
                .focused($activeField, equals: .year)
                
                CustomTextField(title: "CVV", hint: "", value: $card.cvv) {
                    card.cvv = String(card.cvv.prefix(3))
                }
                .focused($activeField, equals: .cvv)
            } //: HSTACK
            .keyboardType(.numberPad)
            
            Spacer(minLength: 0)
            
        } //: VSTACK
        .padding()
        .onChange(of: activeField) { oldValue, newValue in
            withAnimation(.snappy) {
                animateField = newValue
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    activeField = nil
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    @ViewBuilder
    private func CardFrontView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                
                Text("CARD NUMBER")
                    .font(.caption)
                
                /// Displaying a placeholder that will be replaced as the user types
                Text(String(card.rawCardNumber.dummyText("*", count: 16).prefix(16)).group(" ", count: 4))
                    .font(.title2)
                
            } //: VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(AnimatedRing(animateField == .number))
            .frame(maxHeight: .infinity)
            
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("CARD HOLDER")
                        .font(.caption)
                    
                    Text(card.name.isEmpty ? "YOUR NAME": card.name)
                    
                } //: VSTACK Holder
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(AnimatedRing(animateField == .name))
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("EXPIRES")
                        .font(.caption)
                    
                    HStack(spacing: 4) {
                        
                        Text(String(card.month.prefix(2)).dummyText("M", count: 2))
                        Text("/")
                        Text(String(card.year.prefix(2)).dummyText("Y", count: 2))
                        Text(card.cvv)
                        
                    } //: HSTACK
                    
                } //: VSTACK Expiry
                .padding(10)
                .background(AnimatedRing(animateField == .month || animateField == .year))
                
            } //: HSTACK
            
        } //: VSTACK
        .foregroundStyle(.white)
        .monospaced()
        .contentTransition(.numericText())
        .animation(.snappy, value: card)
        .padding(15)
    }
    
    @ViewBuilder
    private func CardBackView() -> some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(.black)
                .frame(height: 45)
                .padding(.horizontal, -15)
                .padding(.top, 10)
            
            VStack(alignment: .trailing, spacing: 6) {
                
                Text("CVV")
                    .font(.caption)
                    .padding(.trailing, 10)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .frame(height: 45)
                    .overlay(alignment: .trailing) {
                        Text(String(card.cvv.prefix(3)).dummyText("*", count: 3))
                            .foregroundStyle(.black)
                            .padding(.trailing, 15)
                    }
            } //: VSTACK
            .foregroundStyle(.white)
            .monospaced()
            
            Spacer(minLength: 0)
            
        } //: VSTACK
        .padding(15)
        .contentTransition(.numericText())
        .animation(.snappy, value: card)
    }
    
    @ViewBuilder
    private func AnimatedRing(_ status: Bool) -> some View {
        if status {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1.5)
                .matchedGeometryEffect(id: "RING", in: animation)
        }
    }
    
}

struct CustomTextField: View {
    
    var title: String
    var hint: String
    @Binding var value: String
    var onChange: () -> Void
    @FocusState private var isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.gray)
            
            TextField(hint, text: $value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .contentShape(.rect)
                .background {
                    /// Changing Stroke Color when active
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isActive ? .blue : .gray.opacity(0.5), lineWidth: 1.5)
                        .animation(.snappy, value: isActive)
                } //: TF
                .focused($isActive)
        } //: VSTACK
        .onChange(of: value) { oldValue, newValue in
            onChange()
        }
    }
    
}

extension String {
    
    func group(_ character: Character, count: Int) -> String {
        var modifiedString = self.replacingOccurrences(of: String(character), with: "")
        
        for index in 0..<modifiedString.count {
            if index % count == 0 && index != 0 {
                let groupedCharactersCount = modifiedString.count(where: { $0 == character })
                let stringIndex = modifiedString.index(modifiedString.startIndex, offsetBy: index + groupedCharactersCount)
                modifiedString.insert(character, at: stringIndex)
            }
        }
        return modifiedString
    }
    
    func dummyText(_ character: Character, count: Int) -> String {
        var tempText = self.replacingOccurrences(of: String(character), with: "")
        let remaining = min(max(count - tempText.count, 0), count)
        
        if remaining > 0 {
            tempText.append(String(repeating: character, count: remaining))
        }
        return tempText
    }
    
}

#Preview {
    ContentView()
}
