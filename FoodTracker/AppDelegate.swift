//
//  AppDelegate.swift
//  FoodTracker
//
//  Created by Paul on 2017-10-08.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        configureParse()
        return true
    }

  
    
    private func configureParse() {
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.Paul.Parse"
            $0.clientKey = "com.Paul.Parse"
            $0.server = "http://paulparsedemo.herokuapp.com/parse"
        }
        Parse.initialize(with: configuration)
        
    }
    
    

}

