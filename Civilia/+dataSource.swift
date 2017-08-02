//
//  +dataSource.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

extension MainViewController {
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //Когда выйдет Swift 4
      return civilmakers.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GeneralTableViewCell
      
      cell.setup(with: self.civilmakers[indexPath.row], viewController: self, indexPath: indexPath)
      
      
      
      //Configuring constraints of theStack
      do {
         
         cell.theStack.widthAnchor.constraint(equalToConstant: cell.theStack.frame.width).isActive = true
         for constraint in cell.contentView.constraints {
            if constraint.identifier == "betweenStackAndStepper" {
               NSLayoutConstraint.deactivate([constraint])
            }
         }
      }
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      
      switch editingStyle {
      case .delete:
         try! realm.write {
            realm.delete(self.civilmakers[indexPath.row])
         }
         tableView.deleteRows(at: [indexPath], with: .left)
      case .insert:
         print(".insert is not implemented")
      default:
         print(".none is not implemented")
      }
      
   }
   
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      let delete = UITableViewRowAction.init(style: .destructive, title: "Delete") { (action, indexPath) in
         
         try! realm.write {
            realm.delete(self.civilmakers[indexPath.row])
         }
         
         tableView.deleteRows(at: [indexPath], with: .automatic)
         
      }
      return [delete]
   }
}
