//
//  TabProperties.swift
//  Draggable Tab Bar
//
//  Created by Matteo Buompastore on 09/07/24.
//

import SwiftUI

@Observable
class TabProperties {
    
    var activeTab: Int = 0
    var editMode: Bool = false
    var tabs: [TabModel] = {
        if let order = UserDefaults.standard.value(forKey: "CustomTabOrder") as? [Int] {
            return defaultOrderTabs.sorted { first, second in
                let firstIndex = order.firstIndex(of: first.id) ?? 0
                let secondIndex = order.firstIndex(of: second.id) ?? 0
                return firstIndex < secondIndex
            }
        }
        return defaultOrderTabs
    }()
    var initalTabLocation: CGRect = .zero
    var movingTab: Int?
    var moveOffset: CGSize = .zero
    var moveLocation: CGPoint = .zero
    var haptics: Bool = false
}
