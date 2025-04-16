//
//  AlarmSettingsView.swift
//  Alarms
//
//  Created by Rishik Dev on 01/08/23.
//

import SwiftUI
import UserNotifications

struct AlarmSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            navigationBar
            
            ScrollView {
                DisclosureGroup("Select a Date and Time") {
                    DatePicker("Select a Date", selection: $selectedDate, in: Date()...)
                        .datePickerStyle(.graphical)
                }
            }
        }
        .buttonStyle(.bordered)
        .padding()
        .interactiveDismissDisabled()
    }
    
    var navigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding(5)
            }
            .clipShape(Circle())
            .tint(.red)
            
            Spacer()
            
            Text("Set Alarm")
            
            Spacer()
            
            Button {
                scheduleNotification()
                dismiss()
            } label: {
                Image(systemName: "checkmark")
                    .padding(5)
            }
            .clipShape(Circle())
                .tint(.green)
        }
        .fontWeight(.black)
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.subtitle = "Swipe to dismiss"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Alarm3.caf"))
        
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct AlarmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSettingsView()
    }
}
