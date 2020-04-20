//
//  Notifications.swift
//  Mouse racing
//
//  Created by Артем Галиев on 16.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications {
    func requestAutorization() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            UIApplication().registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType(rawValue: UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue |
                UIUserNotificationType.badge.rawValue), categories: nil))
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
        }
    }
}
