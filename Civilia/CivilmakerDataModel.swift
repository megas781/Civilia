//
//  CivilmakerDataModel2.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/24/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import RealmSwift
import Foundation
import UIKit
class Civilmaker: Object {
   
   dynamic var fullName: String = ""
   dynamic var civilpoints: Int = 0
   dynamic var dateOfCreation: Date = Date()
   
   
   fileprivate dynamic var storedImageURLString: String? = nil
   fileprivate dynamic var storedImageData : Data? = nil
   
   fileprivate dynamic var id : String = ""
   
   //Index of the cell, the Civilmaker belongs to
   var cellIndex: Int?
   
   //Overrides
   override class func primaryKey() -> String {
      return "id"
   }
   override class func ignoredProperties() -> [String] {
      return ["image","cellIndex"]
   }
}

//Convenience properties
extension Civilmaker {
   var image: UIImage? {
      get {
         return nil
      }
      set {
         
      }
   }
}

//Initializators
extension Civilmaker {
   
   convenience init(fullName: String) {
      self.init()
      
      self.fullName = fullName
      self.id = UUID.init().uuidString
   }
   convenience init(fullName: String, civilpoints: Int) {
      self.init()
      self.fullName = fullName
      self.civilpoints = civilpoints
      self.id = UUID.init().uuidString
   }
}




//Это, чтобы публиковать на стену статистику
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









