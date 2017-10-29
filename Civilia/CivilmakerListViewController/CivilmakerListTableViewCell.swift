//
//  CivilmakerListTableViewCell.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class CivilmakerListTableViewCell: UITableViewCell {
   
   var viewController: CivilmakerListTableViewController!
   var indexPath: IndexPath!
   
   @IBOutlet weak var theImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var civilpointsLabel: UILabel!
   @IBOutlet weak var theStack: UIStackView!
   
   @IBOutlet weak var stepper: UIStepper!
   
   
}
