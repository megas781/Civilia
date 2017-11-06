//
//  Civilmaker+Inits.swift
//  Civilia
//
//  Created by Gleb Kalachev on 11/5/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import RealmSwift
import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

//MARK: REALM_VERSION_ISSUE
//Initializators
//extension Civilmaker {
//   
//   //Создание уже хранящегося на сервере civilmaker'a осуществляется этим инициализатором. Обязательно нужно передать параметр uid, который, в свою очередь, должен быть сгенерирован самим Firebase
//   convenience init(name: String, surname: String, uid: String, civilpoints: Int = 0, dateOfCreation: Date = Date(), image: UIImage? = nil, imageURL: URL? = nil) {
//      
//      //Здесь использую инициализатор, чтобы установить id, так как в этом расширении у меня нет доступа к этому свойству
//      self.init()
//      
//      self.name = name
//      self.surname = surname
//      self.civilpoints = civilpoints
//      self.timeIntervalOfCreationSinceReferenceDate = Date().timeIntervalSinceReferenceDate
//      self.image = image
//      self.storedImageURLString = imageURL?.absoluteString
//      //Установка uid с помощью переданного параметра
//      self.uid = uid
//      
//      //Соединение объекта с референсом
//      self.customServerReference = Database.database().reference().child(FIRPrimeKey.users).child(uid)
//      
//      //Adding observers
//      self.setObservers()
//      
//      
//   }
//   
//   //Инициализатор из словаря. Возвращает nil в случае, если не смог извлечь uid. В такой ситуации не получится связать данный объект с референсом на сервере
//   
//   convenience init?(withDictionary dictWithProperties: Dictionary<String,Any>) {
//      
//      guard let uid = dictWithProperties[CMPropertyKey.uid] as? String else {
//         print("при инициализации из словаря не смог извлечь uid, так что всё напрасно. Возвращаю nil")
//         return nil
//      }
//      
//      self.init()
//      //uid здесь тоже устанавливается
//      self.setValuesForKeys(dictWithProperties)
//      
//      //Связываем с объект с референсом
//      self.customServerReference = Database.database().reference().child(FIRPrimeKey.users).child(uid)
//      
//      //И добавляем наблюдателей
//      self.setObservers()
//      
//   }
//   
//   
//   
//   
//   //Создание нового civilmaker'a, не хранящегося на сервере c автоматически генерирующимся uid
//   static func new(name: String, surname: String, civilpoints: Int = 0, dateOfCreation: Date = Date(), image: UIImage? = nil, imageURL: URL? = nil, completion: @escaping (NSError?, Civilmaker?) -> Void) {
//      
//      let newCivilmaker = Civilmaker()
//      
//      newCivilmaker.name = name
//      newCivilmaker.surname = surname
//      newCivilmaker.civilpoints = civilpoints
//      //Устанавливаю именно timeinterval, а не dateOfCreation, потому что менять dateOfCreation нельзя, а timeIntervalOfCreationSinceReferenceDate - приватный, что уберегает от изменения данных.
//      newCivilmaker.timeIntervalOfCreationSinceReferenceDate = dateOfCreation.timeIntervalSinceReferenceDate
//      newCivilmaker.image = image
//      newCivilmaker.storedImageURLString = imageURL?.absoluteString
//      
//      //Ниже будет установка сгенерированного Firebase'ом uid
//      
//      
//      //Установка uid {
//      //Создал референс на объект...
//      newCivilmaker.customServerReference = Database.database().reference().child(FIRPrimeKey.users).childByAutoId()
//      //...и установил uid со сгенерированным уникальным ключем с помощью .childByAutoId()
//      newCivilmaker.uid = newCivilmaker.customServerReference.key
//      //}
//      
//      //Uploading to the server
//      
//      //Если удалось загрузить данные на сервер...
//      newCivilmaker.customServerReference.setValue(newCivilmaker.getDictionary()) { (error, databaseReference) in
//         
//         guard error == nil else {
//            
//            completion(error! as NSError, nil)
//            return
//         }
//         
//         //Здесь я знаю, что данные были успешно отправлены на сервер, так что можно устанавливать наблюдатели и исполнять completionBlock без error
//         
//         //Установка всех observer'ов
//         newCivilmaker.setObservers()
//         
//         completion(nil, newCivilmaker)
//         
//      }
//      
//   }
//}

