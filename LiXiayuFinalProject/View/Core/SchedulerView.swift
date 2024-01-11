//
//  SchedulerView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/4/23.
//

import SwiftUI
import UserNotifications

struct SchedulerView: View {
    // State variables to hold the notification title, content, and date
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var date: Date = Date()
    // State to store the list of scheduled notifications
    @State private var scheduledNotifications: [UNNotificationRequest] = []

    let notificationHandler = NotificationHandler()
    
    var body: some View {
        VStack {

            // Title for the Scheduler view
            Text("Scheduler")
                .font(.title)
                .fontWeight(.bold)
            
            // Notification Input Section
            VStack(alignment: .leading, spacing: 15) {
                TextField("Title", text: $title)
                TextField("Content", text: $content)
                DatePicker("Date", selection: $date, in: Date()...)  // Restrict DatePicker to future dates
            }
            .padding(.horizontal)
        
            // Button to schedule a notification
            Button(action: {
                notificationHandler.sendNotification(
                    date: date,
                    type: "date",
                    title: title,
                    body: content)
                title = ""
                content = ""
                date = Date()
                fetchScheduledNotifications()  // Refresh the list after scheduling
            }) {
                Text("Schedule Notification")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.title2)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()
            
            if scheduledNotifications.isEmpty {
                // Display a message if there are no scheduled notifications
                Text("No notifications scheduled.")
                    .foregroundColor(.secondary)
            } else {
                // If there are scheduled notifications, list them
                Text("My notification list")
                
                // List each scheduled notification with details
                List(scheduledNotifications, id: \.identifier) { request in
                    VStack(alignment: .leading) {
                        Text(request.content.title).font(.headline)
                        Text(request.content.body)
                        // Display date for date-based triggers
                        if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                           let triggerDate = trigger.nextTriggerDate() {
                            Text("Scheduled for: \(triggerDate)")
                        }
                    }
                }
                .onAppear(perform: fetchScheduledNotifications)
            }
            
            Spacer()
            
            // Help text and button for requesting notification permissions
            Text("Not working?")
                .foregroundColor(.gray)
                .italic()
            Button("Request permissions") {
                notificationHandler.askPermission()
            }
            .foregroundColor(.blue)
            .padding(.bottom, 20)
        }
    }
    
    // Function to retrieve the list of scheduled notifications
    private func fetchScheduledNotifications() {
        notificationHandler.getScheduledNotifications { requests in
            self.scheduledNotifications = requests
        }
    }
}

#Preview {
    SchedulerView()
}
