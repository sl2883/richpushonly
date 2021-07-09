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
        
        let profile: Dictionary<String, Any> = [
            //Update pre-defined profile properties
            "Name": "Rich Push Only",
            "Email": "richpushonly@testrichpushonly.com",
            //Update custom profile properties
            "Plan type": "Silver",
            "Favorite Food": "Pizza"
        ];

        CleverTap.sharedInstance()?.onUserLogin(profile);
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

