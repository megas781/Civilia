//
//  FirebaseDataModel.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/30/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import RealmSwift


struct FIRPrimeKey {
   //   static let allProfiles = "allProfiles"
   static let users = "users"
}

//these keys must be the same as Civilmaker's property names
struct CMPropertyKey {
   static let name = "name"
   static let surname = "surname"
   static let civilpoints = "civilpoints"
   static let timeIntervalOfCreationSinceReferenceDate = "timeIntervalOfCreationSinceReferenceDate"
   static let uid = "uid"
   static let storedImageURLString = "storedImageURLString"
}

/*
 CivilmakerDataManager - the class, which is totally responable for managing data both on the server and in the app
 */
final class CivilmakerDataManager {
   
   static let appServerRef = Database.database().reference()
   
   static func fetchCivilmakers(completion: @escaping ([Civilmaker]) -> Void) {
      print("begin fetching")
      appServerRef.child(FIRPrimeKey.users).observeSingleEvent(of: .value) { (snapshot) in
         
         guard let dictOfCivilmakers = (snapshot.value as? Dictionary<String,Dictionary<String, Any>>) else {
            print("не смог извлечь словарь цивилмейкеров. snapshot: \(snapshot)")
            
            //Completion without civilmakers
            completion([])
            return
         }
         
         //Будущий массив цивилмейкеров
         var civilmakerArray = Array<Civilmaker>()
         
         //Добавление цивилмейкеров в массив civilmakerArray
         for pair in dictOfCivilmakers {
            
//            print("pair: \(pair)")
            
            guard let cm = Civilmaker.init(withDictionary: pair.value) else {
               print("не смог инициализировать civilmaker'a из словарая в методе fetchCivilmakers")
               continue
            }
            
            civilmakerArray.append(cm)
            
         }
         
         civilmakerArray.sort(by: { $0.timeIntervalOfCreationSinceReferenceDate < $1.timeIntervalOfCreationSinceReferenceDate })
         
         //Completion implementation
         completion(civilmakerArray)
      }
      
   }
   
}


