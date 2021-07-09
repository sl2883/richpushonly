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
	- Ensure that CT token, id are in Info.plist of the extension
	- Extend NotificationService from CTNotificationServiceExtension
	- Update the didReceive function as follows
```swift
self.contentHandler = contentHandler
bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

CleverTap.setDebugLevel(3)
CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
super.didReceive(request, withContentHandler: contentHandler)
```
Leave the info.plist as it
	- Keep $(PRODUCT_MODULE_NAME).NotificationService as value for **NSExtensionPrincipalClass**. Changing this value to CTNotificationServiceExtension stops the debugger from hitting the didReceive function of NotificationService class [This needs to be checked further]

**At this point, the images should start working if**
- From CleverTap, we're setting the Advanced options -
	- url for the image (Rich media turned on)
	- mutable-content checked

**Making Push impressions work**
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

**For push impressions to go into the correct profile**
- Add "App groups" capability to main target as well as notification service target
	- From your App developer account, go to Certificates, Identifiers & Profiles -> Identifiers. Find your app & the app extension identifiers.
	- Select your app identifier, click on the App Groups and Configure the identifier to be part of an app group.
	- This step will require you to generate a new provisioning profile for the app identifier. Update the profile in the Xcode to sign your app.
	- Once the app groups are set, from your login - set the identity to the userdefaults
```swift
if let groupUserDefaults = UserDefaults(suiteName: "group.com.sunny.ctios") {
	groupUserDefaults.set("richpushonly@testrichpushonly.com", forKey: "email")
}
```

And in your didReceive function (NotificationService class), read that value and login user - 
```swift
if let groupUserDefaults = UserDefaults(suiteName: "group.com.sunny.ctios") {
	if let email = (groupUserDefaults.object(forKey: "email")) as? String {
		let profile: Dictionary<String, Any> = ["Email": email]
		CleverTap.sharedInstance()?.onUserLogin(profile)
	}
}
```
Now that the user is logged in, call the notificationViewed event -
```swift
CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
```

Also, make sure to call super.didReceive so that the images are rendered correctly.