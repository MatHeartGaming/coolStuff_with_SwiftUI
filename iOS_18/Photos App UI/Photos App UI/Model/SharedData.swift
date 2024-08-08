//
//  SharedData.swift
//  Photos App UI
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

@Observable
class SharedData {
    var activePage: Int = 1
    
    /// True when the Photos Grid ScrollView is expanded
    var isExpanded: Bool = false
    
    /// Main ScrollView Properties
    var mainOffset: CGFloat = 0
    var photosScrollOffset: CGFloat = 0
    var selectedCategory: String = "Years"
    
    /// These properties will be used to evaluate drag conditions, wether the ScrollView can be either pulled up or down for expanding/minimising the ScrollView
    var canPullUp: Bool = false
    var canPullDown: Bool = false
    var progress: CGFloat = 0
}
