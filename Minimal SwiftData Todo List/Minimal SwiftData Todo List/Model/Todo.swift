//
//  Todo.swift
//  Minimal SwiftData Todo List
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    
    private(set) var taskID: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var priority: Priority = Priority.normal
    var lastUpdated: Date = Date.now
    
    init(task: String, isCompleted: Bool = false, priority: Priority = .normal) {
        self.task = task
        self.isCompleted = isCompleted
        self.priority = priority
    }
    
}

enum Priority: String, Codable, CaseIterable {
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    
    /// Priority Color
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
    
}
