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
import FirebaseAuth
import FirebaseDatabase



class Civilmaker: Object {
   
//   static let FIRCurrentUserReference = Auth.auth().currentUser
   
//   @objc dynamic var fullName: String = ""
   @objc dynamic var name: String = ""
   @objc dynamic var surname : String = ""
   
   @objc dynamic var civilpoints: Int = 0
   @objc dynamic var timeIntervalOfCreationSinceReferenceDate: Double = 0.0
   //Мне будет удобнее хранить дату в Double, так как с сервера я буду её именно в Double формате, так что можно будет просто передавать словарь, сгенерированный Realm'ом
//   @objc dynamic var dateOfCreation: Date = Date()
   
   //private properties
   //Is thinking of deprecating imageURL
   @objc private dynamic var storedImageURLString: String? = nil
   
   @objc private dynamic var storedImageData : Data? = nil
   private let storedImageOrientation = RealmOptional<Int>()
   
   @objc private dynamic var uid : String = ""
   
   var customServerReference: DatabaseReference!
   
   
   //Index of the cell, the Civilmaker belongs to
   var cellIndex: Int?
   
   
   
   
   
   
   //Overrides
   override class func primaryKey() -> String {
      return "uid"
   }
   override class func ignoredProperties() -> [String] {
      return ["image","imageURL","cellIndex","fullName","customServerReference"]
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
   
   var dateOfCreation: Date {
      get {
         return Date.init(timeIntervalSinceReferenceDate: self.timeIntervalOfCreationSinceReferenceDate)
      }
      //Дату создания менять нельзя!
//      set {
//         self.timeIntervalOfCreationSinceReferenceDate = 
//      }
   }
   
   
   //Getters
   
   func getFullName() -> String {
      return self.name + " " + self.surname
   }
   
   //Чтобы безопасно доставать uid
   func getUID() -> String {
      return uid
   }
   
   
}

//Initializators
extension Civilmaker {
   
   //Создание уже хранящегося на сервере civilmaker'a осуществляется этим инициализатором. Обязательно нужно передать параметр uid, который, в свою очередь, должен быть сгенерирован самим Firebase
   convenience init(name: String, surname: String, uid: String, civilpoints: Int = 0, dateOfCreation: Date = Date(), image: UIImage? = nil, imageURL: URL? = nil) {
      
      //Здесь использую инициализатор, чтобы установить id, так как в этом расширении у меня нет доступа к этому свойству
      self.init()
      
      self.name = name
      self.surname = surname
      self.civilpoints = civilpoints
      self.timeIntervalOfCreationSinceReferenceDate = Date().timeIntervalSinceReferenceDate
      self.image = image
      self.storedImageURLString = imageURL?.absoluteString
      
      //Соединение объекта с референсом
      self.customServerReference = Database.database().reference().child(FIRPrimeKey.users).child(uid)
      
      //Adding observer
      
   }
   
   //Создание нового civilmaker'a, не хранящегося на сервере
   @discardableResult static func new(name: String, surname: String, civilpoints: Int = 0, dateOfCreation: Date = Date(), image: UIImage? = nil, imageURL: URL? = nil) -> Civilmaker {
      
      let newCivilmaker = Civilmaker()
      
      newCivilmaker.name = name
      newCivilmaker.surname = surname
      newCivilmaker.civilpoints = civilpoints
      //Устанавливаю именно timeinterval, а не dateOfCreation, потому что менять dateOfCreation нельзя, а timeIntervalOfCreationSinceReferenceDate - приватный, что уберегает от изменения данных.
      newCivilmaker.timeIntervalOfCreationSinceReferenceDate = dateOfCreation.timeIntervalSinceReferenceDate
      newCivilmaker.image = image
      newCivilmaker.storedImageURLString = imageURL?.absoluteString
      
      //Ниже будет установка сгенерированного Firebase'ом uid
      
      //Uploading to the server
      
      //Создал референс на объект...
      newCivilmaker.customServerReference = Database.database().reference().child(FIRPrimeKey.users).childByAutoId()
      //...и установил uid со сгенерированным уникальным ключем с помощью .childByAutoId()
      newCivilmaker.uid = newCivilmaker.customServerReference.key
      //Теперь устанавливаем всё остальное
      newCivilmaker.customServerReference.setValue(newCivilmaker.getDictionary())
      
      //Adding obverver, which will post notification, if its value changed
      newCivilmaker.customServerReference.observe(DataEventType.childChanged) { (snapshot) in
//         guard let value = snapshot.value as? String else {
//            print("Не мог извлечь словарь свойств. Snapshot: \(snapshot)")
//            return
//         }
         newCivilmaker.setValue(snapshot.value, forKey: snapshot.key)
         NotificationCenter.default.post(name: userDataChangedNotificationName, object: newCivilmaker, userInfo: nil)
      }
      
      
      return newCivilmaker
   }
}

//Needed functions
extension Civilmaker {
   
   //Functions for Firebase
   func getDictionary() -> [String: Any] {
      return [CMPropertyKey.name:self.name,CMPropertyKey.surname: self.surname,
              CMPropertyKey.civilpoints: self.civilpoints,
              CMPropertyKey.timeIntervalOfCreationSinceReferenceDate: self.dateOfCreation.timeIntervalSinceReferenceDate,
              CMPropertyKey.uid: self.uid]
   }
   
}

//Это, чтобы публиковать на стену статистику
extension Array {
   
   //on revise since alpha 2.09a
//   var civilmakerStringStatistics: String {
//      if self is [Civilmaker] {
//         
//         let array = (self as! [Civilmaker]).sorted(by: { (one, two) -> Bool in
//            return one.civilpoints >= two.civilpoints
//         })
//         
//         var value = "Последние результаты:\n\n"
//         
//         for item in array {
////            value += "\(item.fullName) – \(item.civilpoints) цивилпоинтов\n"
//         }
//         
//         return value
//      } else {
//         return "[no custom implementation]"
//      }
//   }
}










