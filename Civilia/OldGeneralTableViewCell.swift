//
//  GeneralTableViewCell.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import RealmSwift
class OldGeneralTableViewCell: UITableViewCell {
   
   var viewController: OldMainViewController!
   var indexPath: IndexPath!
   var civilmaker: Civilmaker! {
      didSet {
         self.nameLabel.text = civilmaker.fullName
         self.civilPointsLabel.text = String(civilmaker.civilpoints)
         
         if let customImage = civilmaker.image {
            
            self.theImageView.image = customImage
            
         } else {
            
         }
         
         
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
   
   
   func setup(with civilmaker: Civilmaker, viewController: OldMainViewController, indexPath: IndexPath) {
      self.viewController = viewController
      self.indexPath = indexPath
      self.stepper.value = Double(civilmaker.civilpoints)
      
      self.civilmaker = civilmaker
      
      if !realm.isInWriteTransaction {
         try! realm.write {
            civilmaker.cellIndex = indexPath.row
         }
      }
      
      self.theImageView.layer.cornerRadius = self.theImageView.frame.size.height/12
   }
   
   
}
