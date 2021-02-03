//
//  PushNotificationConfig.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 2/1/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
class PushNotificationConfig:NSObject {
    
    let shared = PushNotificationConfig()
    private override init(){}
    
    func config(){
        UNUserNotificationCenter.current().delegate = self
    }
}
extension PushNotificationConfig: UNUserNotificationCenterDelegate {
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])// this will show the notification when app is in forground
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let state = UIApplication.shared.applicationState
        let userInfo = response.notification.request.content.userInfo
        switch state {
        case .active:
            break
        case .background ,.inactive:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               
            }
        @unknown default:
            break
        }
    }
    
}
