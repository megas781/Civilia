//
//  AccountDataModel.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class Account: NSObject, NSCoding {
   
   var fullName: String
   var civilPoints: Int
   
   struct PropertyKey {
      static let fullName = "fullName"
      static let civilPoints = "civilPoints"
   }
   
   
   
   static func save(accounts: [Account]){
      NSKeyedArchiver.archiveRootObject(accounts, toFile: archiveURL.path)
   }
   
   static func getAccounts() -> [Account] {
      
      return NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? [Account] ?? []
      
   }
   
   
   init(fullName: String, civilPoints: Int) {
      
      self.fullName = fullName
      self.civilPoints = civilPoints
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      print("что-то в этом есть")
      
      
      guard let rawName = aDecoder.decodeObject(forKey: PropertyKey.fullName) else {
         print("rawName")
         return nil
      }
      
      guard let fullName = rawName as? String else {
         print("cast of raw name")
         return nil
      }
      
      guard let rawPoints = aDecoder.decodeObject(forKey: PropertyKey.civilPoints) else {
         print("rawPoints")
         return nil
      }
      guard let civilPoints = rawPoints as? NSNumber else {
         print("cast of civil points")
         return nil
      }
      
      print("инициализировал!")
      self.fullName = fullName
      self.civilPoints = Int(civilPoints)
      
   }
   
   func encode(with aCoder: NSCoder) {
      
      aCoder.encode(fullName, forKey: PropertyKey.fullName)
      aCoder.encode(NSNumber.init(value: civilPoints), forKey: PropertyKey.civilPoints)
      
   }

}
