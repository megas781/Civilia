//
//  UIView+animations.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/25/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

extension UIView {
   
   //Это не анимация. Это просто изменение размера
   func resize(withScale scale: CGFloat,animationDuration: TimeInterval = 0.25, animated shouldAnimate: Bool = true) {
      
      if shouldAnimate {
         UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: { 
            self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
         })
      } else {
         self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
      }
   }
   
   func becomePressed(withAnimationDuration animationDuration: TimeInterval = 0.25) {
      self.resize(withScale: 0.83, animationDuration: animationDuration, animated: true)
   }
   
   func resignPressed(withAnimationDuration animationDuration: TimeInterval = 0.25) {
      self.resize(withScale: 1, animationDuration: animationDuration, animated: true)
   }
   
   
   
}
