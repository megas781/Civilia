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
   
   @objc dynamic var fullName: String = ""
   @objc dynamic var civilpoints: Int = 0
   @objc dynamic var dateOfCreation: Date = Date()
   
   
   @objc fileprivate dynamic var storedImageURLString: String? = nil
   
   @objc fileprivate dynamic var storedImageData : Data? = nil
   fileprivate let storedImageOrientation = RealmOptional<Int>()
   
   @objc fileprivate dynamic var id : String = ""
   
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
      set (newImage) {
         if let newImage = newImage {
            self.storedImageData = UIImagePNGRepresentation(newImage)
            self.storedImageOrientation.value = newImage.imageOrientation.rawValue
         } else {
            self.storedImageData = nil
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
   convenience init(fullName: String, civilpoints: Int, dateOfCreation: Date, image: UIImage?, imageURL: URL?) {
      
      //Здесь использую инициализатор, чтобы установить id, так как в этом расширении у меня нет доступа к этому свойству
      self.init(fullName: fullName)
      
      self.civilpoints = civilpoints
      self.dateOfCreation = dateOfCreation
      self.image = image
      self.imageURL = imageURL
      
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










