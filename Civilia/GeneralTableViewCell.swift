//
//  GeneralTableViewCell.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
   
   var viewController: MainViewController!
   var indexPath: IndexPath!
   
   
   //MARK: Outlets
   
   @IBOutlet weak var theImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var civilPointsLabel: UILabel!
   @IBOutlet weak var stepper: UIStepper!
   
   @IBAction func stepperValueChanged(_ stepper: UIStepper) {
      
      
      
   }
   
   //TODO: Загрузи image
   
   
}
