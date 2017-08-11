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
   fileprivate let storedImageOrientation = RealmOptional<Int>()
   
   fileprivate dynamic var id : String = ""
   
   //Index of the cell, the Civilmaker belongs to
   var cellIndex: Int?
   
   
   
   //Overrides
   override class func primaryKey() -> String {
      return "id"
   }
   override class func ignoredProperties() -> [String] {
      return ["image","imageURL","cellIndex"]
   }
   
}

//Convenience properties
extension Civilmaker {
   
   var image: UIImage? {
      get {
         
         if let data = self.storedImageData {
            
            guard let orientation = self.storedImageOrientation.value else {
               fatalError("пустое свойство imageOrientation")
            }
            guard let retrievedImage = UIImage(data: data) else {
               return nil
            }
            switch orientation {
            case 0:
               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .up)
            case 1:
               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .down)
            case 2:
               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .left)
            case 3:
               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .right)
            default:
               fatalError("not implemented case")
            } 
            
            
         } else {
            return nil
         }
      }
      set {
         if let newValue = newValue {
            self.storedImageData = UIImagePNGRepresentation(newValue)
            self.storedImageOrientation.value = newValue.imageOrientation.rawValue
         }
      }
   }
   
   var imageURL: URL? {
      get {
         if let string = self.storedImageURLString {
            return URL(string: string)
         } else {
            return nil
         }
      }
      set {
         self.storedImageURLString = newValue?.absoluteString
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
         
         let array = (self as! [Civilmaker]).sorted(by: { (one, two) -> Bool in
            return one.civilpoints >= two.civilpoints
         })
         
         var value = "Последние результаты:\n\n"
         
         for item in array {
            value += "\(item.fullName) – \(item.civilpoints) цивилпоинтов\n"
         }
         
         return value
      } else {
         return "[no custom implementation]"
      }
   }
}









