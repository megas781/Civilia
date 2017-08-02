//
//  GeneralTableViewCell.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import RealmSwift
class GeneralTableViewCell: UITableViewCell {
   
   var viewController: MainViewController!
   var indexPath: IndexPath!
   var civilmaker: Civilmaker! {
      willSet {
         self.nameLabel.text = newValue.fullName
         self.civilPointsLabel.text = String(newValue.civilpoints)
      }
   }
   
   var realm: Realm!
   
   //MARK: Outlets
   
   @IBOutlet weak var theImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var civilPointsLabel: UILabel!
   @IBOutlet weak var theStack: UIStackView!
   
   @IBOutlet weak var stepper: UIStepper!
   
   
   
   override func awakeFromNib() {
      realm = try! Realm()
   }
   
   @IBAction func stepperValueChanged(_ stepper: UIStepper) {
      
      if !realm.isInWriteTransaction {
         try! realm.write {
            civilmaker.civilpoints = Int(stepper.value)
         }
      }
      self.viewController.tableView.reloadRows(at: [self.indexPath], with: .none)
      
   }
   
   
   func setup(with civilmaker: Civilmaker, viewController: MainViewController, indexPath: IndexPath) {
      self.viewController = viewController
      self.indexPath = indexPath
      self.stepper.value = Double(civilmaker.civilpoints)
      
      self.civilmaker = civilmaker
      
      if !realm.isInWriteTransaction {
         try! realm.write {
            civilmaker.cellIndex = indexPath.row
         }
      }
   }
   
   
}
