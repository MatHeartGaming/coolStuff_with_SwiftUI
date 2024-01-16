//
//  Home.swift
//  CreditCard Input Form
//
//  Created by Matteo Buompastore on 16/01/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    @FocusState private var activeTF: ActiveKeyboardField!
    @State private var cardNumber = ""
    @State private var cardHolderName = ""
    @State private var cvvCode = ""
    @State private var expireDate = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                /// Header
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundStyle(.black)
                    })
                    
                    Text("Add Card")
                        .font(.title3)
                        .padding(.leading, 10)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}, label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                        
                    })
                    
                } //: HSTACK
                
                /// CardView
                CardView()
                
                Spacer(minLength: 0)
                
                Button(action: {}, label: {
                    Label("Add Card", systemImage: "lock")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue.gradient)
                        }
                })
                /// Disabling action until all card details are filled
                .disableWithOpacity(cardNumber.count != 19 || expireDate.count != 5 || cardHolderName.isEmpty || cvvCode.count != 3)
                
            } //: VSTACK
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            /// Keyboard change button
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    /// No button needed for last item
                    if activeTF != .cardHolder {
                        Button("Next") {
                            switch activeTF {
                            case .cardNumber:
                                activeTF = .expirationDate
                            case .cardHolder: break
                            case .expirationDate:
                                activeTF = .cvv
                            case .cvv:
                                activeTF = .cardHolder
                            case .none: break
                            }
                        }
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } //: TOOLBAR ITEM NEXT BUTTON ON KEYBOARD
            } //: TOOLBAR
        }
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    func CardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.linearGradient(
                    colors: [.cardGradient1, .cardGradient2],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            
            /// Card Details
            VStack(spacing: 10) {
                HStack {
                    TextField("XXXX XXXX XXXX XXXX", text: .init(get: {
                        cardNumber
                    }, set: { value in
                        cardNumber = ""
                        
                        /// Inserting spaces every 4 digitis
                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let stringIndex = value.index(startIndex, offsetBy: index)
                            cardNumber += String(value[startIndex])
                            if (index + 1) % 5 == 0 && value[stringIndex] != " " {
                                cardNumber.insert(" ", at: stringIndex)
                            }
                        }
                        
                        /// Removing empty space when going back
                        if value.last == " " {
                            cardNumber.removeLast()
                        }
                        
                        /// Limiting to 16 digits
                        cardNumber = String(cardNumber.prefix(19))
                        
                    }))
                    .font(.title3)
                    .keyboardType(.numberPad)
                    .focused($activeTF, equals: .cardNumber)
                    //                    .onChange(of: cardNumber, initial: activeTF == .cardNumber, { oldValue, newValue in
                    //                        if oldValue != newValue{
                    //                            if newValue.count == 4 && oldValue.count == 3{
                    //                                cardNumber = newValue + " "
                    //                            } else if oldValue.count == 8 && newValue.count == 9{
                    //                                cardNumber = newValue + " "
                    //                            } else if oldValue.count == 13 && newValue.count == 14{
                    //                                cardNumber = newValue + " "
                    //                            } else if oldValue.count == 18 && newValue.count == 19{
                    //                                cardNumber = newValue + " "
                    //                            } else if oldValue.count == 23{
                    //                                cardNumber = oldValue
                    //                            }
                    //                        }
                    //                        return
                    //                    })
                    
                    Spacer(minLength: 0)
                    
                    Image(.visa)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(height: 30)
                } //: HSTACK
                
                HStack(spacing: 12) {
                    TextField("MM/YY", text: .init(get: {
                        expireDate
                    }, set: { value in
                        expireDate = value
                        /// Insertiing slash in the third place
                        if value.count == 3 && !value.contains("/") {
                            let startIndex = value.startIndex
                            let thirdPosition = value.index(startIndex, offsetBy: 2)
                            expireDate.insert("/", at: thirdPosition)
                        }
                        
                        /// Removing / when going back
                        if value.last == "/" {
                            expireDate.removeLast()
                        }
                        
                        /// Limiting size
                        expireDate = String(expireDate.prefix(5))
                        
                    }))
                    .focused($activeTF, equals: .expirationDate)
                    .keyboardType(.numberPad)
                    
                    Spacer(minLength: 0)
                    
                    TextField("CVV", text: .init(get: {
                        cvvCode
                    }, set: { value in
                        cvvCode = value
                        cvvCode = String(cvvCode.prefix(3))
                    }))
                    .frame(width: 35)
                    .keyboardType(.numberPad)
                    .focused($activeTF, equals: .cvv)
                    
                    Image(systemName: "questionmark.circle.fill")
                } //: HSTACK
                .padding(.top, 15)
                
                Spacer(minLength: 0)
                
                TextField("CARD HOLDER NAME", text: $cardHolderName)
                    .focused($activeTF, equals: .cardHolder)
                    .submitLabel(.done)
                
            } //: VSTACK
            .padding(20)
            
        }
        .frame(height: 200)
        .padding(.top, 35)
    }
    
}

#Preview {
    Home()
}


/// Disable with opacity extension
extension View {
    
    @ViewBuilder
    func disableWithOpacity(_ status: Bool) -> some View {
        self
            .disabled(status)
            .opacity(status ? 0.6 : 1)
    }
    
}
