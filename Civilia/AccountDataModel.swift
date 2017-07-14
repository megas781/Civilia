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
   
   
   //MARK: Coding
   required init?(coder aDecoder: NSCoder) {
      
      guard let fullName = aDecoder.decodeObject(forKey: PropertyKey.fullName) as? String,
      let civilPoints = aDecoder.decodeObject(forKey: PropertyKey.civilPoints) as? NSNumber
      else {
         return nil
      }
      
      self.fullName = fullName
      self.civilPoints = Int(civilPoints)
      
   }
   func encode(with aCoder: NSCoder) {
      
      aCoder.encode(fullName, forKey: PropertyKey.fullName)
      aCoder.encode(NSNumber.init(value: civilPoints), forKey: PropertyKey.civilPoints)
      
   }

}
