//
//  TestModel.swift
//  InteractiveWidget
//
//  Created by Matteo Buompastore on 08/01/24.
//

import Foundation

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCompleted: Bool = false
}


/// Sample Data model
class TaskDataModel {
    static let shared = TaskDataModel()
    
    var tasks: [TaskModel] = [
        .init(taskTitle: "Record Video!"),
        .init(taskTitle: "Edit Video"),
        .init(taskTitle: "Publish it!"),
    ]
}
