//
//  ThingView.swift
//  A Better Day Workshop
//
//  Created by MicroBanker Nepal Pvt. Ltd. on 22/06/2025.
//

import SwiftUI
import SwiftData

struct ThingsView: View {
    
    @Query(filter: #Predicate<Thing> { $0.isHidden == false })
          private var things: [Thing]
    
    @State private var showAddView: Bool = false
    
    var body: some View {

        VStack (alignment: .leading, spacing: 20) {
            
            Text("Things")
                .font(.largeTitle)
                .bold()
            
            Text("These are the things that make you feel positive and uplifted.")
            
            List (things) { thing in
                Text(thing.title)                
            }
            .listStyle(.plain)
            
            Spacer()
            Button("Add New Thing") {
                showAddView.toggle()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .sheet(isPresented: $showAddView) {
            AddThingView()
                .presentationDetents(
                    [.fraction(0.2)])
        }
    }
}

#Preview {
    ThingsView()
}
