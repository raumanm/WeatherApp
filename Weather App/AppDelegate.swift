//
//  AppDelegate.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let temp = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + "/cache.txt";

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        NSLog("Attempting to save state");
        do {
            let data = NSKeyedArchiver.archivedData(withRootObject: DataHandler.state);
            try data.write(to: URL(fileURLWithPath: temp));
            NSLog("Saved State to \(temp)");
        } catch {
            NSLog("Unable to Save application state");
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NSLog("Attempting to load state from \(temp)");
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: temp));
            let state = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! AppDataState;
            
            DataHandler.state = state;
            NSLog("Loaded state");
            //DataHandler.debugPrint(state);
        } catch {
            NSLog("Unable to load state");
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        NSLog("Should save App State?");
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        NSLog("Should load App State?");
        return true
    }}

