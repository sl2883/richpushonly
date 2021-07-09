
//
//  NotificationService.swift
//  NotificationServiceExtention
//
//  Created by Sunny Ladkani on 7/9/21.
//

import UserNotifications
import CleverTapSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
        
        if let groupUserDefaults = UserDefaults(suiteName: "group.com.sunny.ctios") {
              if let email = (groupUserDefaults.object(forKey: "email")) as? String {
              let profile: Dictionary<String, Any> = ["Email": email]
               print("[Clevertap] Email" + " logged in to the service extension")
               CleverTap.sharedInstance()?.onUserLogin(profile)
               testEvent(email: email)
           }
        }

        
        CleverTap.setDebugLevel(3)
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
    }
    
    func testEvent(email: String) {
        let props: Dictionary<String, Any> = [
            "Email": "email"
        ]

        CleverTap.sharedInstance()?.recordEvent("Logged in", withProps: props)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
