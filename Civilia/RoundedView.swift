//
//  RoundedView.swift
//  Civilia_Simulator
//
//  Created by Gleb Kalachev on 9/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import Foundation
@IBDesignable class RoundedView: UIView {

   
   
   
   @IBInspectable var theCornerRadius: CGFloat {
      get {
//         self.clipsToBounds = true
         return self.layer.cornerRadius
      }
      set {
//         self.clipsToBounds = true
         self.layer.cornerRadius = newValue
      }
   }
   override func awakeFromNib() {
      self.clipsToBounds = true
   }
}
