//
//  Animations.swift
//  VKActive
//
//  Created by Gleb Kalachev on 7/13/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

let animationDuration: TimeInterval = 0.1
let defaultScale : CGFloat = 0.85

extension UIView {
   
   //MARK: Changing values
   private func resize(withScale scale: CGFloat) {
      self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
   }
   
   //MARK: Directly animations
   
   func resizeAnimation(withScale scale: CGFloat) {
      UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: { 
         self.resize(withScale: scale)
      }) { (bool) in
         
      }
   }
   
   
   
}
