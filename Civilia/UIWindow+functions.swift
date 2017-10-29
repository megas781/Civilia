//
//  UIViewController+functions.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

extension UIWindow {
   
   func dimAndShowLoading() {
      let dimView = UIView.init(frame: self.frame)
      dimView.backgroundColor = .black
      dimView.alpha = 0.3
      
      let activityIndecator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
      activityIndecator.startAnimating()
      activityIndecator.center = dimView.center
      
      dimView.addSubview(activityIndecator)
      self.addSubview(dimView)
      
      
   }
   
}
