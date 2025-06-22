//
//  Day.swift
//  A Better Day Workshop
//
//  Created by MicroBanker Nepal Pvt. Ltd. on 22/06/2025.
//

import Foundation
import SwiftData

@Model

class Day : Identifiable {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var things = [Thing]()
    
    init() {
        
    }
}

extension Day {
    static func currentDaypredicate() -> Predicate<Day> {
        
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: Date.now)
        
        return #Predicate<Day>{ $0.date >= start}
    }
}
