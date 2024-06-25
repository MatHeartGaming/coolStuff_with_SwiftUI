//
//  ContentView.swift
//  Text Selection API
//
//  Created by Matteo Buompastore on 25/06/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var text: String = "Hello World"
    
    /// (Maybe) Due to a bug in the beta version of iOS 18 we cannot leave the selection uninitialised
    @State private var selection: TextSelection? = .init(insertionPoint: "".startIndex)
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                TextEditor(text: $text, selection: $selection)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .frame(height: 150)
                    .background(.background, in: .rect(cornerRadius: 10))
                
                VStack  {
                    HStack {
                        
                        
                        Button("Move After Hello World") {
                            if let range = text.range(of: "Hello") {
                                let endIndex = range.upperBound
                                selection = .init(insertionPoint: endIndex)
                            }
                        }
                        
                        Button("Select Hello World") {
                            if let range = text.range(of: "Hello") {
                                selection = .init(range: range)
                            }
                        }
                    } //: HSTACK
                    
                    HStack {
                        Button("Move To First") {
                            selection = .init(insertionPoint: text.startIndex)
                        }
                        Button("Move To Last") {
                            selection = .init(insertionPoint: text.endIndex)
                        }
                    } //: HSTACK
                    
                    if let selectedTextRange, text[selectedTextRange] == "Hello" {
                        Button("Replace With Hello Guys") {
                            text.replaceSubrange(selectedTextRange, with: "Hello Guys!")
                            let startIndex = selectedTextRange.lowerBound
                            let length = "Hello Guys".count
                            let endIndex = text.index(startIndex, offsetBy: length)
                            let newRange: Range<String.Index> = .init(uncheckedBounds: (startIndex, endIndex))
                            selection = .init(range: newRange)
                        }
                    }
                    
                } //: VSTACK
                
                Spacer(minLength: 0)
                    
            } //: VSTACK
            .padding(15)
            .navigationTitle("Text Selection API")
            .background(.gray.opacity(0.1))
            /*.onChange(of: selection) { oldValue, newValue in
                if let selection = newValue, !selection.isInsertion {
                    print(selection.indices)
                    switch selection.indices {
                        case .selection(let range):
                        let selectedText = text[range]
                        print(selectedText)
                    
                    default:
                        print("Others")
                        
                    }
                }
            }*/
            
        } //: NAVIGATION
    }
    
    
    var selectedTextRange: Range<String.Index>? {
        if let selection, !selection.isInsertion {
            switch selection.indices {
            case .selection(let range): return range
                
            default: return nil
            }
        }
        return nil
    }
    
}

#Preview {
    ContentView()
}
