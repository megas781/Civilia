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
   
   //private properties (temporarily: everything, what is fileprivated, will be just private in a sooner Realm update)
   //Is thinking of deprecating imageURL
   
   @objc fileprivate dynamic var storedImageURLString: String? = nil
   
   @objc fileprivate dynamic var storedImageData : Data? = nil
   private let storedImageOrientation = RealmOptional<Int>()
   
   @objc fileprivate dynamic var uid : String = ""
   
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
   
   
   deinit {
      //После деинициализации нужно удалить обзерверы. В принципе, не знаю, насколько это нужно. Так как крашей не было, а customServerReference и сам исчезнет после деинициализации объекта
//      self.customServerReference.removeAllObservers()
   }
}


//Temporarily I have to put these extensions back because current RealmSwift (installed via cocoapods) works in swift 3.2 and doesn't support private properties in extensions.

//MARK: REALM_VERSION_ISSUE
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
      //Установка uid с помощью переданного параметра
      self.uid = uid
      
      //Соединение объекта с референсом
      self.customServerReference = Database.database().reference().child(FIRPrimeKey.users).child(uid)
      
      //Adding observers
      self.setObservers()
      
      
   }
   
   //Инициализатор из словаря. Возвращает nil в случае, если не смог извлечь uid. В такой ситуации не получится связать данный объект с референсом на сервере
   
   convenience init?(withDictionary dictWithProperties: Dictionary<String,Any>) {
      
      guard let uid = dictWithProperties[CMPropertyKey.uid] as? String else {
         print("при инициализации из словаря не смог извлечь uid, так что всё напрасно. Возвращаю nil")
         return nil
      }
      
      self.init()
      //uid здесь тоже устанавливается
      self.setValuesForKeys(dictWithProperties)
      
      //Связываем с объект с референсом
      self.customServerReference = Database.database().reference().child(FIRPrimeKey.users).child(uid)
      
      //И добавляем наблюдателей
      self.setObservers()
      
   }
   
   
   
   
   //Создание нового civilmaker'a, не хранящегося на сервере c автоматически генерирующимся uid
   static func new(name: String, surname: String, civilpoints: Int = 0, dateOfCreation: Date = Date(), image: UIImage? = nil, imageURL: URL? = nil, completion: @escaping (NSError?, Civilmaker?) -> Void) {
      
      let newCivilmaker = Civilmaker()
      
      newCivilmaker.name = name
      newCivilmaker.surname = surname
      newCivilmaker.civilpoints = civilpoints
      //Устанавливаю именно timeinterval, а не dateOfCreation, потому что менять dateOfCreation нельзя, а timeIntervalOfCreationSinceReferenceDate - приватный, что уберегает от изменения данных.
      newCivilmaker.timeIntervalOfCreationSinceReferenceDate = dateOfCreation.timeIntervalSinceReferenceDate
      newCivilmaker.image = image
      newCivilmaker.storedImageURLString = imageURL?.absoluteString
      
      //Ниже будет установка сгенерированного Firebase'ом uid
      
      
      //Установка uid {
      //Создал референс на объект...
      newCivilmaker.customServerReference = Database.database().reference().child(FIRPrimeKey.users).childByAutoId()
      //...и установил uid со сгенерированным уникальным ключем с помощью .childByAutoId()
      newCivilmaker.uid = newCivilmaker.customServerReference.key
      //}
      
      //Uploading to the server
      
      //Если удалось загрузить данные на сервер...
      newCivilmaker.customServerReference.setValue(newCivilmaker.getDictionary()) { (error, databaseReference) in
         
         guard error == nil else {
            
            completion(error! as NSError, nil)
            return
         }
         
         //Здесь я знаю, что данные были успешно отправлены на сервер, так что можно устанавливать наблюдатели и исполнять completionBlock без error
         
         //Установка всех observer'ов
         newCivilmaker.setObservers()
         
         completion(nil, newCivilmaker)
         
      }
      
   }
}

//MARK: REALM_VERSION_ISSUE
//Needed functions
extension Civilmaker {
   
   //Functions for Firebase
   func getDictionary() -> [String: Any] {
      return [CMPropertyKey.name:self.name,CMPropertyKey.surname: self.surname,
              CMPropertyKey.civilpoints: self.civilpoints,
              CMPropertyKey.timeIntervalOfCreationSinceReferenceDate: self.dateOfCreation.timeIntervalSinceReferenceDate,
              CMPropertyKey.uid: self.getUID()]
   }
   
   //Метод для установки наблюдателей
   private func setObservers() {
      
      //Adding obverver, which will post notification, if its value changed
      self.customServerReference.observe(DataEventType.childChanged) { (snapshot) in
         self.setValue(snapshot.value, forKey: snapshot.key)
         NotificationCenter.default.post(name: userDataChangedNotificationName, object: self, userInfo: nil)
      }
      self.customServerReference.observe(DataEventType.childAdded) { (snapshot) in
         
         print("added snapshot: \(snapshot)")
         //         fatalError("Объекту Civilmaker было добавлено новое свойство, что ПОКА ЧТО не предусмотрено функционалом приложения. snapshot: \(snapshot)")
         
         //         NotificationCenter.default.post(name: userDataChangedNotificationName, object: self, userInfo: nil)
      }
      self.customServerReference.observe(DataEventType.childRemoved) { (snapshot) in
         
         print("removed snapshot: \(snapshot)")
         //         fatalError("Свойство объекта Civilmaker было удалено, что не предусмотрено функционалом приложения. snapshot: \(snapshot)")
         
         //         NotificationCenter.default.post(name: userDataChangedNotificationName, object: self, userInfo: nil)
      }
      
   }
   
}


//MARK: REALM_VERSION_ISSUE
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











