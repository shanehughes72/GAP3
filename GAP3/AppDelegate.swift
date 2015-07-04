//
//  AppDelegate.swift
//  GAP3
//
//  Created by Worship Arts on 5/28/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

import UIKit
import Parse
import Bolts



struct GPXURL {
    static let Notification = "GPXURL Radio Station"
    static let Key = "GPXURL URL Key"
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
    {
        // post a notification when a GPX file arrives
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: GPXURL.Notification, object: self, userInfo: [GPXURL.Key:url])
        center.postNotification(notification)
        return true
    }
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var isLoggedIn = false
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("oAKaU6OfE9Ad3Z28zRO2ut8KMcEgaKjelmQeCARS",
            clientKey: "k81qP4GFlxgLDOAaM5ND8W2qUWDgo7yoaMrnir6o")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
         if (PFUser.currentUser() != nil) {
            
            
            
            isLoggedIn = true
            print("from appDelegate - PFUser.currentUser():")
            print(PFUser.currentUser())
        }// server response
        
        //var storyboardId = ""
        
        
        let storyboardId = isLoggedIn ? "UINavigationController" : "SignUpInViewController"
        
        print("storyboardId is  \(storyboardId)", appendNewline: true)
        
               // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        let initViewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(storyboardId)") as UIViewController
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = initViewController
        self.window!.makeKeyAndVisible()
        
        
        
        
        
        /*
        
        var storyboard = UIStoryboard()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initViewController = UIViewController()
        initViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
        UIStoryboard storyboard = UIStoryboard.storyboardWithName:"Storyboard" bundle:nil
        UIViewController initViewController = storyboard.instantiateViewControllerWithIdentifier:storyboardId
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initViewController
        self.window.makeKeyAndVisible
        
        */
        return true
    }

    
}

