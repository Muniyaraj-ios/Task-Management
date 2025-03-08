//
//  NotificationManager.swift
//  Task Management
//
//  Created by MAC on 07/03/25.
//

import Foundation
import UserNotifications
import CoreLocation

final class NotificationManager{
    
    static let instance = NotificationManager()
    
    private init() {}
    
    func requestAuthorizaion(){
        let notificationoption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: notificationoption) { success, error in
            if let error = error{
                print("Error on Notification : \(error.localizedDescription)")
            }else{
                print("Notification Permission : \(success)")
            }
        }
    }
    
    func scheduleNotification(with taskData: TaskData){
        scheduleCalendarNotification(with: taskData)
        locationBasedNotification(with: taskData)
    }
    
}

extension NotificationManager{
    
    private func scheduleCalendarNotification(with taskData: TaskData) {
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder: \(taskData.title)"
        content.body = taskData.desc
        content.sound = .default
        content.badge = 1
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: taskData.due_date)
        
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(taskData.notificationId)\(MapKeySettings.calendar)", content: content, trigger: calendarTrigger)
        
        UNUserNotificationCenter.current().add(request)
        
        print("Calendar notification scheduled for \(taskData.title) at \(taskData.due_date)")
    }
}

extension NotificationManager{
    
    private func locationBasedNotification(with taskData: TaskData) {
        
        let coordinate = taskData.coordinate
        let region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(MapKeySettings.coordinate_region), identifier: taskData.notificationId)
        
        if region.notifyOnEntry {
            let entryContent = UNMutableNotificationContent()
            entryContent.title = "You arrived at \(taskData.title)"
            entryContent.body = "Reminder: \(taskData.desc)"
            entryContent.sound = .default
            entryContent.badge = 1
            
            let entryTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
            let entryRequest = UNNotificationRequest(identifier: "\(taskData.notificationId)\(MapKeySettings.entryKey)", content: entryContent, trigger: entryTrigger)
            
            UNUserNotificationCenter.current().add(entryRequest)
        }
        
        if region.notifyOnExit {
            let exitContent = UNMutableNotificationContent()
            exitContent.title = "You left \(taskData.title)"
            exitContent.body = "Don't forget: \(taskData.desc)"
            exitContent.sound = .default
            exitContent.badge = 1
            
            let exitTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
            let exitRequest = UNNotificationRequest(identifier: "\(taskData.notificationId)\(MapKeySettings.exitKey)", content: exitContent, trigger: exitTrigger)
            
            UNUserNotificationCenter.current().add(exitRequest)
        }
        
        print("Notifications scheduled... Entry & Exit for: \(taskData.title) | ID: \(taskData.notificationId)")
    }
}

extension NotificationManager{
    
    func cancelNotification(with notificationid: String){
        let notificationIds = ["\(notificationid)\(MapKeySettings.exitKey)",
                               "\(notificationid)\(MapKeySettings.entryKey)",
                               "\(notificationid)\(MapKeySettings.calendar)"]
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: notificationIds)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIds)
    }
    
    func canelNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
