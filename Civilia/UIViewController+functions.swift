//
//  UIViewController+functions.swift
//  Civilia
//
//  Created by Gleb Kalachev on 11/1/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

extension UIViewController {
   
   private var dimViewUniqueTag : Int { return 228322 }
   
   func dimAndDisplayLoading() {
      let dimView = UIView.init(frame: window.frame)
      dimView.backgroundColor = .black
      dimView.alpha = 0.3
      dimView.tag = self.dimViewUniqueTag
      
      let activityIndecator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
      activityIndecator.startAnimating()
      activityIndecator.center = dimView.center
      
      dimView.addSubview(activityIndecator)
      self.view.addSubview(dimView)
   }
   
   func brightenAndResignLoading() {
      self.view.viewWithTag(dimViewUniqueTag)?.removeFromSuperview()
   }
   
   
}
