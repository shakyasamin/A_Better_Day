//
//  AddThingView.swift
//  A Better Day Workshop
//
//  Created by MicroBanker Nepal Pvt. Ltd. on 22/06/2025.
//

import SwiftUI
import SwiftData

struct AddThingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    @State private var thingTitle = ""
    
    var body: some View {
        VStackLayout(alignment: .leading, spacing: 10) {
            TextField("What makes you feel good?", text: $thingTitle)
                .textFieldStyle(.roundedBorder)
            
            Button("Add") {
                // Add into swiftData
                addThings()
                
                thingTitle = ""
                
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(thingTitle
                .trimmingCharacters(in:
                        .whitespacesAndNewlines)
                    .isEmpty)
        }
        .padding()
        
    }
    
    func addThings() {
        //clean text
        let cleanedtext = thingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Add into DB
        context.insert(Thing(title: cleanedtext))
        
        try? context.save()
    }
}

#Preview {
    AddThingView()
}
