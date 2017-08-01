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
   
   
   //Overrides
   override class func primaryKey() -> String {
      return "id"
   }
   override class func ignoredProperties() -> [String] {
      return ["image"]
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



//Полезность для создания массива из results
extension Results {
   
   var array: [T] {
      let array: [T] = self.map { (item) -> T in
         return item
      }
      switch array {
      case _ where array is [Civilmaker]:
         
         //Здесь кастим до [Civilmaker], сортируем и возвращаем как [T]
         return (array as! [Civilmaker]).sorted(by: { (one, two) -> Bool in
            return one.dateOfCreation > two.dateOfCreation
         }) as! [T]
         
      default:
         print("Array ordering for this Results<T> generic type is not implemented")
         return array
      }
      
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









