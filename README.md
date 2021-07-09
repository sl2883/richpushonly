 - Start with a basic project with CleverTap set up using the steps mentioned [here](https://developer.clevertap.com/docs/ios-quickstart-guide#section-install-sdk)
	 - Get the SDK
	 - Update the Info.plist with id and token
- Integrate basic CT
```swift
CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
CleverTap.autoIntegrate();
```
- Enable Push notifications (basic baground and killed state)
	- Register for push - [ref](https://github.com/sl2883/richpushonly/blob/3a1840254f91420f7359afd0440c39e905e8e621/RichPushOnly/AppDelegate.swift#L23)
	- Ensure that Push notifications and background mode are added to the capabilities
- Add the notification service extension
	- By just sending a push now, with mutable-content flag checked, the breakpoint should hit the receive function of the extension
- Add CTNotificationService in the pod file for the extension - [ref](https://github.com/CleverTap/CTNotificationService)
	- pod  'CTNotificationService' and run pod install
	- Set the NSExtensionPrincipalClass in Info.plist to CTNotificationServiceExtension

**At this point, the images should start working if**
- From CleverTap, we're setting the Advanced options -
	- url for the image (Rich media turned on)
	- mutable-content checked

Making Push impressions work
- Update the Podfile so now our service extension also depends on CleverTap SDK
```swift
target 'NotificationServiceExtention'  do
	pod 'CTNotificationService'
	pod "CleverTap-iOS-SDK"
end
```
- Update the NotificationService class to raise an event for CleverTap to record notification viewed (Push impression in the backend)
```swift
CleverTap.setDebugLevel(3)
CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
```

