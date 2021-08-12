//
//  ViewController.swift
//  RichPushOnly
//
//  Created by Sunny Ladkani on 7/9/21.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController, CleverTapInboxViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login1(sender: UIButton) {
        print("login1");
        
        let identity = "a3443535";
        
        let profile: Dictionary<String, Any> = [
            //Update pre-defined profile properties
            "Name": "A 34 User",
            "Email": "a3443535@test.com",
            "Identity": identity,
            //Update custom profile properties
            "Plan type": "Silver",
            "Favorite Food": "Pizza",
            "Phone": "+15109447171"
        ];
        

        CleverTap.sharedInstance()?.onUserLogin(profile);
        if let groupUserDefaults = UserDefaults(suiteName: "group.com.sunny.ctios") {
               groupUserDefaults.set(identity, forKey: "identity")
        }
        
        testEvent(identity: identity)
        launchCTInbox()
    }
    
    func testEvent(identity: String) {
        let props: Dictionary<String, Any> = [
            "Identity": identity
        ]

        CleverTap.sharedInstance()?.recordEvent("Logged in main", withProps: props)
    }
    
    func launchCTInbox () {
        // config the style of App Inbox Controller
            let style = CleverTapInboxStyleConfig.init()
            style.title = "App Inbox"
            style.backgroundColor = UIColor.lightGray
            style.messageTags = ["tag1", "tag2"]
            style.navigationBarTintColor = UIColor.gray
            style.navigationTintColor = UIColor.blue
            style.tabUnSelectedTextColor = UIColor.black
            style.tabSelectedTextColor = UIColor.white
            style.tabSelectedBgColor = UIColor.black
            style.firstTabTitle = "My First Tab"
            
            if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                let navigationController = UINavigationController.init(rootViewController: inboxController)
                self.present(navigationController, animated: true, completion: nil)
          }
    }
    
    @IBAction func pv(sender: UIButton) {
        print("product viewed");
        
        let props: Dictionary<String, Any> = [
            "Product name": "Casio Chronograph Watch",
            "Category": "Mens Accessories",
            "Price": 59.99,
            "Date": NSDate()
        ]

        CleverTap.sharedInstance()?.recordEvent("Product viewed", withProps: props)
    }
    
    @IBAction func pp(sender: UIButton) {
        print("product purc");
        
        let props: Dictionary<String, Any> = [
            "Product name": "Casio Chronograph Watch",
            "Category": "Mens Accessories",
            "Price": 59.99,
            "Date": NSDate()
        ]

        CleverTap.sharedInstance()?.recordEvent("Product purchased", withProps: props)
    }
}

