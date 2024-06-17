//
//  DummyControlBundle.swift
//  DummyControl
//
//  Created by Matteo Buompastore on 17/06/24.
//

import WidgetKit
import SwiftUI

@main
struct DummyControlBundle: WidgetBundle {
    var body: some Widget {
        DummyControl()
        DummyControlControl()
    }
}
