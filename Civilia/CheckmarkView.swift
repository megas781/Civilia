//
//  CheckmarkView.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/11/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class CheckmarkView: UIImageView {

   
   /*CheckmarkStatus – переменная, вместо image'a показывающая текущий статус checkmark'a. Переопределяется в complemetion'e публичных методов анимации animateEmergence(withStatus:), animateChange(withStatus:) и AnimateDisappearing(). Важно использовать именно status для detection'ов checkmark'a*/
   enum CheckmarkStatus {
      case positive, negative, unspecified
   }
   var status: CheckmarkStatus!
   
   
   
   override func awakeFromNib() {
      if self.image == nil {
         self.status = .unspecified
      } else {
         switch self.image! {
         case #imageLiteral(resourceName: "checkmark"):
            self.status = .positive
         case #imageLiteral(resourceName: "exclamation_mark"):
            self.status = .negative
         default:
            self.status = .unspecified
         }
      }
   }
   
   //Первая – для появления
//   private 
   
   func animateEmergence(withStatus status: CheckmarkStatus) {
      switch status {
      case .positive:
         self.status = .positive
         self.animateEmergence(withImage: #imageLiteral(resourceName: "checkmark"))
      case .negative:
         self.status = .negative
         self.animateEmergence(withImage: #imageLiteral(resourceName: "exclamation_mark"))
      default:
         self.status = .unspecified
         print("animateEmergence with unspecified status – странная вещь")
      }
   }
   
   
   
   //Вторая – для смены
//   private 
   
   func animateChange(toStatus status: CheckmarkStatus) {
      switch status {
      case .positive:
         self.status = CheckmarkStatus.positive
         self.animateChange(toImage: #imageLiteral(resourceName: "checkmark"))
      case .negative:
         self.status = CheckmarkStatus.negative
         self.animateChange(toImage: #imageLiteral(resourceName: "exclamation_mark"))
      default:
         print("animateChange to unspecified case – странная вещь")
      }
   }
   
   //Третья – для исчезновения
   
   func animateDisappearing() {
      print("overrided disappearing")
      //Устанавливаем статус checkmark'a ДО анимации!
      self.status = CheckmarkStatus.unspecified
      self.animateDisappearing(withDuration: 0.3)
   }
   
}
