
//
//  NotificationService.swift
//  NotificationServiceExtention
//
//  Created by Sunny Ladkani on 7/9/21.
//

import UserNotifications
import CleverTapSDK
import CTNotificationService

import CleverTapSDK

class NotificationService: CTNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let groupUserDefaults = UserDefaults(suiteName: "group.com.sunny.ctios") {
              if let identity = (groupUserDefaults.object(forKey: "Identity")) as? String {
              let profile: Dictionary<String, Any> = ["Identity": identity]
               print("[Clevertap] Identity" + " logged in to the service extension")
               CleverTap.sharedInstance()?.onUserLogin(profile)
               testEvent(identity: identity)
           }
        }

        
        
        CleverTap.setDebugLevel(3)
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
        super.didReceive(request, withContentHandler: contentHandler)
    }
    
    func testEvent(identity: String) {
        let props: Dictionary<String, Any> = [
            "Identity": identity
        ]

        CleverTap.sharedInstance()?.recordEvent("Logged in notification service", withProps: props)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
