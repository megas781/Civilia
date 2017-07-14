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
      
      viewController.accounts[indexPath.row].civilpoints = Int(stepper.value)
      
//      NSKeyedArchiver.archiveRootObject(self.viewController.accounts, toFile: archiveURL.path)
      Account.save(accounts: self.viewController.accounts)
      
      viewController.tableView.reloadData()
      
   }
   
   //TODO: Загрузи image
   func updateUI(with account: Account) {
      self.nameLabel.text = account.fullName
      self.civilPointsLabel.text = "\(account.civilpoints)"
      self.stepper.value = Double(account.civilpoints)
   }
   
   
}
