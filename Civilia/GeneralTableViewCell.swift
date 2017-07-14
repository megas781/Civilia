//
//  GeneralTableViewCell.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
   
   var viewController: UIViewController!
   var indexPath: IndexPath!
   
   
   //MARK: Outlets
   
   @IBOutlet weak var theImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var numberOfPointsLabel: UILabel!
   
   override func prepareForReuse() {
      print("reuse with indexPath: \(indexPath)")
   }
   
}
