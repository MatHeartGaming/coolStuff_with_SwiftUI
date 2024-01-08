//
//  ToggleStateIntent.swift
//  InteractiveWidget
//
//  Created by Matteo Buompastore on 08/01/24.
//

import SwiftUI
import AppIntents

struct ToggleStateIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Toggle task state"
    
    /// Parameters
    @Parameter(title: "Task ID")
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        /// Update your data here
        if let index = TaskDataModel.shared.tasks.firstIndex(where: { $0.id == id }) {
            TaskDataModel.shared.tasks[index].isCompleted.toggle()
            print("Updated")
        }
        return .result()
    }
}
