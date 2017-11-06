//
//  Civilmaker+ConvenienceProperties.swift
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
////Convenience properties
//extension Civilmaker {
//   
//   var image: UIImage? {
//      get {
//         
//         if let data = self.storedImageData {
//            
//            guard let orientation = self.storedImageOrientation.value else {
//               fatalError("пустое свойство imageOrientation")
//            }
//            guard let retrievedImage = UIImage(data: data) else {
//               return nil
//            }
//            switch orientation {
//            case 0:
//               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .up)
//            case 1:
//               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .down)
//            case 2:
//               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .left)
//            case 3:
//               return UIImage(cgImage: retrievedImage.cgImage!, scale: 1, orientation: .right)
//            default:
//               fatalError("not implemented case")
//            } 
//            
//            
//         } else {
//            return nil
//         }
//      }
//      set (newImage) {
//         if let newImage = newImage {
//            self.storedImageData = UIImagePNGRepresentation(newImage)
//            self.storedImageOrientation.value = newImage.imageOrientation.rawValue
//         } else {
//            self.storedImageData = nil
//         }
//      }
//   }
//   
//   var dateOfCreation: Date {
//      get {
//         return Date.init(timeIntervalSinceReferenceDate: self.timeIntervalOfCreationSinceReferenceDate)
//      }
//      //Дату создания менять нельзя!
//      //      set {
//      //         self.timeIntervalOfCreationSinceReferenceDate = 
//      //      }
//   }
//   
//   
//   //Getters
//   
//   func getFullName() -> String {
//      return self.name + " " + self.surname
//   }
//   
//   //Чтобы безопасно доставать uid
//   func getUID() -> String {
//      return uid
//   }
//   
//}

