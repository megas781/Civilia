//
//  CivilmakerDataModel2.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/24/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import RealmSwift

class Civilmaker: Object {
   
   dynamic var fullName: String = ""
   dynamic var civilpoints: Int = 0
   dynamic var dateOfCreation: Date = Date()
   
   private dynamic var imageURLString: String? = nil
   private dynamic var imageData : Data? = nil
   
   //
//   dynamic var image : UIImage? {
//      get {
//         if let data = self.imageData {
//            return UIImage(data: data)
//         } else {
//            return nil
//         }
//      }
//      set {
//         if let image = newValue {
//            self.imageData = UIImagePNGRepresentation(image)
//         } else {
//            self.imageData = nil
//         }
//      }
//   }
   
   
   //getting image
   func getImage() -> UIImage? {
      if let data = self.imageData,
         let image = UIImage(data: data) {
         
         return image
         
      } else {
         //В противном случае, придется чекать URL
         if let _ /*url*/ = self.imageURLString {
            
            print("No URL realisation")
            return nil
         }
         
         return nil
         
      }
   }
   //setting image
   func setImage(image: UIImage?) {
      if let image = image {
         self.imageData = UIImagePNGRepresentation(image)
      } else {
         self.imageData = nil
      }
   }
   
   //Sample initializer
   static func `init`(fullName: String) -> Civilmaker {
      
      let newCM = Civilmaker()
      
      newCM.fullName = fullName
      
      
      return newCM
      
   }
//   Full initializer
   static func `init`(fullName: String, civilpoints: Int, image: UIImage?, imageURL: URL?) -> Civilmaker {
      
      let newCM = Civilmaker()
      newCM.fullName = fullName
      newCM.civilpoints = civilpoints
      newCM.dateOfCreation = Date()
      
      //MARK: Maybe rewise this
      if let image = image {
         newCM.setImage(image: image)
      } else {
         newCM.imageURLString = imageURL?.absoluteString
      }
      
      return newCM
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









