//
//  DateTF.swift
//  DatePicker TextField Input
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

struct DateTF: View {
    
    // MARK: - Properties
    var components: DatePickerComponents = [.date, .hourAndMinute]
    @Binding var date: Date
    var formattedString: (Date) -> String
    
    /// UI
    @State private var viewID: String = UUID().uuidString
    @FocusState private var isActive: Bool
    
    var body: some View {
        TextField(viewID, text: .constant(formattedString(date)))
            .focused($isActive)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isActive = false
                    }
                    .tint(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            /// The Overlay prevents interaction with the TF. If you can use background instead.
            .overlay {
                AddInputViewToTF(id: viewID) {
                    /// SwiftUI Date Picker
                    DatePicker("", selection: $date, displayedComponents: components)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                .onTapGesture {
                    isActive = true
                }
            }
    }
}

fileprivate struct AddInputViewToTF<Content: View>: UIViewRepresentable {
    
    var id: String
    @ViewBuilder var content: Content
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let window = view.window, 
                let textField = window.allSubviews(type: UITextField.self).first(where: { $0.placeholder == id }) {
                
                /// Hiding cursor
                textField.tintColor = .clear
                
                /// Converting SwiftUI View to UIKit View
                let hostView = UIHostingController(rootView: content).view!
                hostView.backgroundColor = .clear
                hostView.frame.size = hostView.intrinsicContentSize
                
                /// Adding as Input
                textField.inputView = hostView
                textField.reloadInputViews()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

fileprivate extension UIView {
    func allSubviews<T: UIView>(type: T.Type) -> [T] {
        var resultViews = subviews.compactMap({ $0 as? T })
        
        for view in subviews {
            resultViews.append(contentsOf: view.allSubviews(type: type))
        }
        return resultViews
    }
}

#Preview {
    ContentView()
}
