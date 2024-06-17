//
//  DummyControlControl.swift
//  DummyControl
//
//  Created by Matteo Buompastore on 17/06/24.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DummyControlControl: ControlWidget {
    static let kind: String = "it.matbuompy.new-in-ios18.ControlCenterAPI.DummyControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            /*ControlWidgetToggle(isOn: SharedManager.shared.isTurnedOn,
             action: DummyControlIntent()) { isTurnedOn in
             Image(systemName: isTurnedOn ? "fan.fill" : "fan")
             Text(isTurnedOn ? "Turned On" : "Turned Off")
             } label: {
             Text("Living Room")
             }
             
             }*/
            ControlWidgetButton(action: CaffeineUpdateIntent(amount: 10)) {
                Image(systemName: "cup.and.saucer.fill")
                Text("Caffeine Intake")
                let amount = SharedManager.shared.caffeineIntake
                Text("\(String(format: "%.1f", amount)) mgs")
            }
        }
    }
}
    
struct CaffeineUpdateIntent: AppIntent {
    static var title: LocalizedStringResource {
        "Update Caffeine Intake"
    }
    
    init() {}
    
    init(amount: Double) {
        self.amount = amount
    }
    
    @Parameter(title: "Amount Taken")
    var amount: Double
    
    func perform() async throws -> some IntentResult {
        /// Update contents here
        SharedManager.shared.caffeineIntake += amount
        return .result()
    }
}

struct DummyControlIntent: SetValueIntent {
    static var title: LocalizedStringResource {
        "Turn On Living Room Fan"
    }
    
    @Parameter(title: "is Turned On")
    var value: Bool
    
    func perform() async throws -> some IntentResult {
        /// Update content here
        SharedManager.shared.isTurnedOn = value
        return .result()
    }
}
