//
//  SettingsView.swift
//  A Better Day Workshop
//
//  Created by MicroBanker Nepal Pvt. Ltd. on 22/06/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            List {
                //Rate the aopp
                
                let reviewUrl = URL(string: "htps://apps.apple.com/app/id123456?action=write-review")!
                
                Link(destination: reviewUrl, label: {
                    HStack {
                        Image(systemName: "star.bubble")
                        Text("Rate the app")
                    }
                })
                
                //Recommend the app
                let shareUrl = URL(string: "https://apps.cpple.com/app/id123456")!
                
                ShareLink(item: shareUrl) {
                    HStack{
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("Recommend the app")
                    }
                }
                
                //Contact
                
                Button {
                    //Compose mail
                    let mailUrl = createMailUrl()
                    
                    if let mailUrl = mailUrl,
                       UIApplication.shared.canOpenURL(mailUrl) {
                        UIApplication.shared.open(mailUrl)
                    }else {
                        print("Couldn't open mal client")
                    }
                } label : {
                    HStack {
                        Image(systemName: "quote.bubble")
                        Text("Submit feedback")
                    }
                }
                
                //Privacy policy
                let privacyUrl = URL(string: "hrrps://codewithcrist.com/add-privacy-policy/")!
                
                Link(destination: privacyUrl, label: {
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Privacy Policy")
                    }
                })
                
            }
        
            
        }
    }
    
    func createMailUrl() -> URL? {
        var mailUrlComponents = URLComponents()
        mailUrlComponents.scheme = "mailto"
        mailUrlComponents.path = "care@codewithchris.com"
        mailUrlComponents.queryItems = [
            URLQueryItem(name: "subject", value: "Feedback for a Better Day App")
            ]
        return mailUrlComponents.url
    }
    
    
}

#Preview {
    SettingsView()
}
