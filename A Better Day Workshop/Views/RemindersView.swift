//
//  RemindersView.swift
//  A Better Day Workshop
//
//  Created by MicroBanker Nepal Pvt. Ltd. on 22/06/2025.
//

import SwiftUI
import SwiftData

struct RemindersView: View {
    
    @AppStorage("ReminderTime") private var reminderTme: Double = Date().timeIntervalSince1970
    
    @AppStorage("RemindersOn") private var isRemindersOn = false
    @State private var selectedDate = Date().addingTimeInterval(86400)
    @State private var isSettingDialogShowing = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Text("Remainders")
                .font(.largeTitle)
                .bold()
            Text("Remind yourself to do something uplifting everyday.")
            
            Toggle( isOn: $isRemindersOn) {
                Text("Toggle reminders")
            }
            
            if isRemindersOn {
                HStack {
                    Text("What time?")
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                }
            }
        }
        .onAppear(perform: {
            selectedDate = Date(timeIntervalSince1970: reminderTme)
        })
        .onChange(of: isRemindersOn) { oldValue, newValue in
            //TODO: Check for permissions to send notifications
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    print("Notifications are suthorized.")
                    //TODO: Schedule the notifications
                    scheduleNotifications()
                case .denied:
                    print("Notifications are denied.")
                    isRemindersOn = false
                    //TODO: Show a dialog saying that we can't send notifications and have a button to send the user to settings
                    
                    isSettingDialogShowing = true
                case.notDetermined:
                    print("Notification permission has not been asked yet.")
                    //Request it
                    
                    requestNotificationPermission()
                default:
                    break
                }
            }
            
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            //Unsechedule all currently schedule reminders
            notificationCenter.removeAllPendingNotificationRequests()
            
            //Sechedule new reminders
            scheduleNotifications()
            
            //TODO: Save new time
            reminderTme = selectedDate.timeIntervalSince1970
            
        }
        .alert(isPresented: $isSettingDialogShowing) {
            Alert(title: Text("Notifications Disabled"), message: Text("Reminders won't be sent unless Notifications are allowed.Please allow them in Settnigs."), primaryButton: .default(Text("Go to Settings"), action: {
                //Goto settings
                goToSettings()
            }), secondaryButton: .cancel())
        }
    }
    
    func goToSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString){
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
                //TODO: Schedule the notifications
                scheduleNotifications()
            } else {
                print("permission denied.")
                
                //TODO: Showing a dialog saying that we can't send notifications and have a button to send the user to settings
                
                isSettingDialogShowing = true
            }
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        //Create the content of the notification]
        let content = UNMutableNotificationContent()
        content.title = "A Better Day"
        content.body = "Don't forget to do something for yourself today!"
        content.sound = .default
        
        //Define the time components for the notification
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.autoupdatingCurrent.component(.hour, from: selectedDate)
        dateComponents.minute = Calendar.autoupdatingCurrent.component(.minute, from: selectedDate)
        
        //create a trigger that repeats every day at the specified time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //create the notification request with a unique identifier
        
        let request = UNNotificationRequest(identifier: UUID().uuidString , content: content, trigger: trigger)
        
        //schedule the notification
        notificationCenter.add(request){ error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }else {
                print("Daily notification scheduled.")
            }
        }
    }
}

#Preview {
    RemindersView()
}
