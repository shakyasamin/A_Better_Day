//
//  TodayView.swift
//  A Better Day Workshop
//
//  Created by MicroBanker Nepal Pvt. Ltd. on 22/06/2025.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(filter: Day.currentDaypredicate(),sort: \.date) private var today: [Day]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Today")
                .font(.largeTitle)
                .bold()
            
            Text("Try to do things that make you feel positive today.")
            
            //Only display the list if there are things don today
            if getToday().things.count > 0 {
                List(getToday().things) { thing in
                    Text(thing.title)
                }
            }else {
                //Display the image and some tool tips
            }
        }
    }
    
    func getToday() -> Day {
        
        // Try to retrieve today from the database
        if today.count > 0 {
            return today.first!
        }
        else {
            //If it doesn't exist, create a day and insert it
            let today = Day()
            context.insert(today)
            try? context.save()
            
            return today
        }
        
    }
}
#Preview {
    TodayView()
}
