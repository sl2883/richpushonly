//
//  ViewController.swift
//  RichPushOnly
//
//  Created by Sunny Ladkani on 7/9/21.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController {

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
    }
    
    func testEvent(identity: String) {
        let props: Dictionary<String, Any> = [
            "Identity": identity
        ]

        CleverTap.sharedInstance()?.recordEvent("Logged in main", withProps: props)
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

