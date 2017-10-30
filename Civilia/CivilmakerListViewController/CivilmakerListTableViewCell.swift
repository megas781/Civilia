//
//  CivilmakerListTableViewCell.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class CivilmakerListTableViewCell: UITableViewCell {
   
   
   //Outlets
   @IBOutlet weak var theImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var civilpointsLabel: UILabel!
   @IBOutlet weak var theStack: UIStackView!
   
   @IBOutlet weak var stepper: UIStepper!
   
   
   //Properties
   var viewController: CivilmakerListTableViewController!
   var indexPath: IndexPath!
   
   func setupOutlets(withCivilmaker civilmaker: Civilmaker) {
      
      /*This method sets only and only outlets. Things such as viewController and indexPath are set separately in cellForRowAtIndexPath method */
      
      //setting civilmaker
      self.nameLabel.text = civilmaker.getFullName()
      self.civilpointsLabel.text = String(civilmaker.civilpoints)
      self.stepper.value = Double(civilmaker.civilpoints)
      
   }
   
}
