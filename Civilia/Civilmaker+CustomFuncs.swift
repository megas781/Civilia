//
//  Civilmaker+CustomFuncs.swift
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
////Needed functions
//extension Civilmaker {
//   
//   //Functions for Firebase
//   func getDictionary() -> [String: Any] {
//      return [CMPropertyKey.name:self.name,CMPropertyKey.surname: self.surname,
//              CMPropertyKey.civilpoints: self.civilpoints,
//              CMPropertyKey.timeIntervalOfCreationSinceReferenceDate: self.dateOfCreation.timeIntervalSinceReferenceDate,
//              CMPropertyKey.uid: self.getUID()]
//   }
//   
//   //Метод для установки наблюдателей
//   private func setObservers() {
//      
//      //Adding obverver, which will post notification, if its value changed
//      self.customServerReference.observe(DataEventType.childChanged) { (snapshot) in
//         self.setValue(snapshot.value, forKey: snapshot.key)
//         NotificationCenter.default.post(name: userDataChangedNotificationName, object: self, userInfo: nil)
//      }
//      self.customServerReference.observe(DataEventType.childAdded) { (snapshot) in
//         
//         print("added snapshot: \(snapshot)")
//         //         fatalError("Объекту Civilmaker было добавлено новое свойство, что ПОКА ЧТО не предусмотрено функционалом приложения. snapshot: \(snapshot)")
//         
//         //         NotificationCenter.default.post(name: userDataChangedNotificationName, object: self, userInfo: nil)
//      }
//      self.customServerReference.observe(DataEventType.childRemoved) { (snapshot) in
//         
//         print("removed snapshot: \(snapshot)")
//         //         fatalError("Свойство объекта Civilmaker было удалено, что не предусмотрено функционалом приложения. snapshot: \(snapshot)")
//         
//         //         NotificationCenter.default.post(name: userDataChangedNotificationName, object: self, userInfo: nil)
//      }
//      
//   }
//   
//}

