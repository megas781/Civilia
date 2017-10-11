//
//  UIImageView+animations.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/1/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

extension UIImageView {
   //Первая – для появления
   func animateEmergence(withImage image: UIImage,animationDuration: TimeInterval = 0.4) {
      DispatchQueue.main.async {
         
         //Уменьшам view
         self.transform = CGAffineTransform.init(scaleX: 0, y: 0)
         //Присваиваем изображение
         self.image = image
         //Даем видимость
         self.alpha = 1
         
         UIView.animate(withDuration: animationDuration/3, delay: 0,options: [], animations: { 
            self.transform = CGAffineTransform.init(scaleX: 1.25, y: 1.25)
         }, completion: { (_) in
            UIView.animate(withDuration: animationDuration/3, delay: 0, options: [.curveLinear], animations: { 
               self.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            }, completion: { (_) in
               UIView.animate(withDuration: animationDuration/3, delay: 0, options:[.curveEaseOut], animations: { 
                  self.transform = CGAffineTransform.identity
               })
            })
         })
      }
   }
   //Вторая – для смены
   func animateChange(toImage image: UIImage,animationDuration: TimeInterval = 0.27) {
      
      DispatchQueue.main.async {
         
         UIView.animate(withDuration: animationDuration/3, delay: 0,options: [], animations: { 
            //Затихание: view уменьшается и исчезает
            self.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            self.alpha = 0.5
            
         }, completion: { (bool) in
            
            //На второй части анимации, где view уже начинает увеличиваться, можно присвоить image
            self.image = image
            
            UIView.animate(withDuration: animationDuration/3, delay: 0, options: [.curveLinear], animations: {
               
               //Расширение
               self.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
               self.alpha = 1
            }, completion: { (bool) in
               UIView.animate(withDuration: animationDuration/3, delay: 0, options:[.curveEaseOut], animations: { 
                  
                  //Завершение
                  self.transform = CGAffineTransform.identity
               })
            })
         })
      }
   }
   
   func animateDisappearing(withDuration animationDuration: TimeInterval = 0.3) {
      
      DispatchQueue.main.async {
         UIView.animate(withDuration: animationDuration / 3, delay: 0, options: [], animations: { 
            self.transform = CGAffineTransform.init(scaleX: 1.34, y: 1.34)
            
         }) { (bool) in
            UIView.animate(withDuration: animationDuration * 2 / 3, delay: 0, options: [], animations: { 
               self.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
//               self.alpha = 0
            }, completion: { (bool) in
               self.image = nil
            })
         }
      }
   }
}
