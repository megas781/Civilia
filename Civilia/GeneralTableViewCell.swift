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
      
      
//      Civilmaker.save(accounts: self.viewController.accounts)
      
      viewController.tableView.reloadData()
      
   }
   
   //TODO: Загрузи image
   func updateUI(with account: Civilmaker) {
      self.nameLabel.text = account.fullName
      self.civilPointsLabel.text = "\(account.civilpoints)"
      self.stepper.value = Double(account.civilpoints)
      
      
      self.theImageView.layer.cornerRadius = self.theImageView.frame.size.height/8
      
      self.theImageView.image = account.getImage() ?? UIImage(named: "wreath")
      
//      self.theImageView.image = UIImage.init(cgImage: account.image!.cgImage!, scale: 1, orientation: {
//         () -> UIImageOrientation in
//         switch account.image!.imageOrientation {
//         case .up :
//            return .down
//         case .down:
//            return .up
//         case .left:
//            return .up
//         case .right:
//            return .up
//         default:
//            fatalError("orientation error")
//         }
//      }()
//      )
      
      //Правило такое: если есть image, то url не используется
      
//      if let image = account.image {
//         self.theImageView.image = image
//      } else {
//         if let url = account.imageURL {
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//               
//               guard let data = data else {
//                  print("не смог извлечь data")
//                  return
//               }
//               guard let image = UIImage(data: data) else {
//                  print("не смог докастить до UIImage")
//                  return
//               }
//               
//               DispatchQueue.main.async {
//                  self.theImageView.image = image
//               }
//               
//            })
//         }
//      }
   }
   
   
}
