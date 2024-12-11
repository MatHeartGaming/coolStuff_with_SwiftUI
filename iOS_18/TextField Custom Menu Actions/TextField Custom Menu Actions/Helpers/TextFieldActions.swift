//
//  TextFieldActions.swift
//  TextField Custom Menu Actions
//
//  Created by Matteo Buompastore on 11/12/24.
//

import SwiftUI

extension TextField {
    
    @ViewBuilder
    func menu(showSuggestion: Bool = true, @TextFieldActionBuilder actions: @escaping () -> [TextFieldAction]) -> some View {
        self
            .background(TextFieldActionHelper(showSuggestions: showSuggestion, actions: actions()))
            .compositingGroup()
    }
    
}

struct TextFieldAction {
    
    var title: String
    var action: (NSRange, UITextField) -> Void
    
}

@resultBuilder
struct TextFieldActionBuilder {
    
    static func buildBlock(_ components: TextFieldAction...) -> [TextFieldAction] {
        components.compactMap({ $0 })
    }
    
}

fileprivate struct TextFieldActionHelper: UIViewRepresentable {
    
    var showSuggestions: Bool
    var actions: [TextFieldAction]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let textField = view.superview?.superview?.subviews.last?.subviews.first as? UITextField {
                context.coordinator.originalDelegate = textField.delegate
                textField.delegate = context.coordinator
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: TextFieldActionHelper
        
        init(parent: TextFieldActionHelper) {
            self.parent = parent
        }
        
        var originalDelegate: UITextFieldDelegate?
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            originalDelegate?.textFieldDidChangeSelection?(textField)
        }
        
        func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
            var actions: [UIMenuElement] = []
            let customActions = parent.actions.compactMap { item in
                let action = UIAction(title: item.title) { _ in
                    item.action(range, textField)
                }
                return action
            }
            if parent.showSuggestions {
                actions = customActions + suggestedActions
            } else {
                actions = customActions
            }
            
            let menu = UIMenu(children: actions)
            return menu
        }
        
    }
    
}

#Preview {
    ContentView()
}
