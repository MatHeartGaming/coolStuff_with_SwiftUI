//
//  ContentView.swift
//  TextField Custom Menu Actions
//
//  Created by Matteo Buompastore on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var message: String = ""
    @State private var selection: TextSelection?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Textfield") {
                    TextField("Message", text: $message, selection: $selection)
                        .menu(showSuggestion: true) {
                            TextFieldAction(title: "Uppercased") { _, tf in
                                if let selectionRange = tf.selectedTextRange,
                                   let selectedText = tf.text(in: selectionRange) {
                                    let uppercasedText = selectedText.uppercased()
                                    tf.replace(selectionRange, withText: uppercasedText)
                                    
                                    /// To avoid selection disappearing
                                    tf.selectedTextRange = selectionRange
                                }
                            } //: Action uppercase
                            
                            TextFieldAction(title: "Lowercased") { _, tf in
                                if let selectionRange = tf.selectedTextRange,
                                   let selectedText = tf.text(in: selectionRange) {
                                    let lowercasedText = selectedText.lowercased()
                                    tf.replace(selectionRange, withText: lowercasedText)
                                    
                                    /// To avoid selection disappearing
                                    tf.selectedTextRange = selectionRange
                                }
                            } //: Action lowercase
                            
                            TextFieldAction(title: "Replace") { range, tf in
                                if let selectionRange = tf.selectedTextRange {
                                    let replacementText = "Hello World!"
                                    tf.replace(selectionRange, withText: replacementText)
                                    if let start = tf.position(from: selectionRange.start, offset: 0),
                                       let end = tf.position(from: selectionRange.start, offset: replacementText.count) {
                                        
                                        tf.selectedTextRange = tf.textRange(from: start, to: end)
                                        
                                    }
                                }
                            } //: Action lowercase
                        } //: SECTION TF
                    
                    Section {
                        Text(message)
                    }
                    
                    Section {
                        if let selection, !selection.isInsertion {
                            Text("Some text is selected")
                        }
                    }
                    
                } //: LIST
                .navigationTitle("Custom TextField Menu")
            } //: NAVIGATION
        }
    }
    
}

#Preview {
    ContentView()
}
