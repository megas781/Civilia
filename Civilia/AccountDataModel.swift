//
//  AccountDataModel.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class Account: NSObject, NSCoding {
   
   
   //MARK: Properties
   var fullName: String
   var civilpoints: Int
   
   var imageURL: URL? = nil {
      didSet {
         
      }
   }
   var image: UIImage? = nil {
      didSet {
         
      }
   }
   
   struct PropertyKey {
      static let fullName = "fullName"
      static let civilPoints = "civilPoints"
   }
   
   
   
   
   
   init(fullName: String, civilPoints: Int) {
      
      self.fullName = fullName
      self.civilpoints = civilPoints
      
   }
   
   //MARK: Static methods
   
   static func save(accounts: [Account]){
      NSKeyedArchiver.archiveRootObject(accounts, toFile: archiveURL.path)
   }
   
   static func getAccounts() -> [Account] {
      
      return NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? [Account] ?? []
      
   }
   
   //MARK: Coding
   required init?(coder aDecoder: NSCoder) {
      
      guard let fullName = aDecoder.decodeObject(forKey: PropertyKey.fullName) as? String,
      let civilPoints = aDecoder.decodeObject(forKey: PropertyKey.civilPoints) as? NSNumber
      else {
         return nil
      }
      
      self.fullName = fullName
      self.civilpoints = Int(civilPoints)
      
   }
   func encode(with aCoder: NSCoder) {
      
      aCoder.encode(fullName, forKey: PropertyKey.fullName)
      aCoder.encode(NSNumber.init(value: civilpoints), forKey: PropertyKey.civilPoints)
      
   }

}
