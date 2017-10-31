//
//  AppDelegate.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      FirebaseApp.configure()
      
      
      
      let config = Realm.Configuration.init(schemaVersion: 7, migrationBlock: {
         (migration,oldSchemaVersion) in 
         
         migration.renameProperty(onType: Civilmaker.className(), from: "id", to: "uid")
         
      })
      
      Realm.Configuration.defaultConfiguration = config
      
      return true
   }
      
   
   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }
   
   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      // Saves changes in the application's managed object context before the application terminates.
      //TODO: FIX_IT
      //      Civilmaker.save(accounts: ((self.window!.rootViewController as! UINavigationController).viewControllers.first as! MainViewController).accounts)
   }
   
}

//fileprivate func parse(string: String) {
//   
//   let realm = try! Realm()
//   
//   try! realm.write {
//      realm.deleteAll()
//   }
//   
//   let lines = string.characters.split(separator: "\n").map({String($0)})
//   
//   for i in lines {
//      
//      //Делаю это, чтобы изменять line
//      var line = i
//      
//      var fullName = ""
//      fullName = line.getPrefixWithFirstFoundSymbol("–")
//      fullName.removeLast()
//      
//      line.removePrefixWithFirstFoundSymbol("–")
//      line.removePrefixWithLength(2)
//      
//      let civilpoints = Int(line.getPrefixWithFirstFoundSymbol(" "))!
//      
//      //Here we have right data
//      
//      try! realm.write {
////         realm.add(Civilmaker.init(name: "[name]", surname: "[surname]", civilpoints: 228322))
//      }
//      
//   }
//   
//}

//AppDelegate, к свойству window которого я буду обращаться
let appDelegate = UIApplication.shared.delegate as! AppDelegate
