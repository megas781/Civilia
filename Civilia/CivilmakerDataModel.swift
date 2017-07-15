//
//  AccountDataModel.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class Civilmaker: NSObject, NSCoding {
   
   
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
      static let imageData = "image"
      static let imageURLString = "imageURL"
   }
   
   
   
   
   
   init(fullName: String, civilpoints: Int) {
      
      self.fullName = fullName
      self.civilpoints = civilpoints
      
   }
   
   //Полный инициализатор
   convenience init(fullName: String, civilpoints: Int, image: UIImage?, imageURL: URL?) {
      
      self.init(fullName: fullName, civilpoints: civilpoints)
      
      self.imageURL = imageURL
      self.image = image
      
   }
   
   //MARK: Static methods
   
   static func save(accounts: [Civilmaker]){
      NSKeyedArchiver.archiveRootObject(accounts, toFile: archiveURL.path)
   }
   
   static func getAccounts() -> [Civilmaker] {
      
      return NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? [Civilmaker] ?? []
      
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
      
      
      
      if let data = aDecoder.decodeObject(forKey: PropertyKey.imageData) as? Data {
         self.image = UIImage(data: data)
      } else {
         print("не нашел image")
      }
      
      if let imageURLString = aDecoder.decodeObject(forKey: PropertyKey.imageURLString) as? String,
         let imageURL = URL.init(string: imageURLString) {
         self.imageURL = imageURL
      } else {
         print("не нашел URL")
      }
      
   }
   
   func encode(with aCoder: NSCoder) {
      
      aCoder.encode(fullName, forKey: PropertyKey.fullName)
      aCoder.encode(NSNumber.init(value: civilpoints), forKey: PropertyKey.civilPoints)
      
      if let image = self.image,
         let data = UIImagePNGRepresentation(image) {
         aCoder.encode(data, forKey: PropertyKey.imageData)
      }
      
      if let urlString = self.imageURL?.absoluteString {
         aCoder.encode(urlString, forKey: PropertyKey.imageURLString)
      }
      
   }
   
   override var description: String  {
      return "\(self.fullName) - \(self.civilpoints) civilpoints"
   }
   
}

internal let archiveURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!.appendingPathComponent("accounts")


extension Array {
   var civilmakerStringStatistics: String {
      if self is [Civilmaker] {
         
         let array = self as! [Civilmaker]
         
         var value = "Last loaded results:\n\n"
         
         for item in array {
            value += "\(item.description)\n"
         }
         
         return value
      } else {
         return "[no custom implementation]"
      }
   }
}
