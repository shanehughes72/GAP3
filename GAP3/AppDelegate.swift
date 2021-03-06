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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


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
            
            println(isLoggedIn)
        }// server response
        
        //var storyboardId = ""
        
        
        var storyboardId = isLoggedIn ? "UINavigationController" : "SignUpInViewController"
        
        println("storyboardId is  \(storyboardId)")
        
        
        
        
        
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        let initViewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(storyboardId)") as! UIViewController
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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

