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
      return 3
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GeneralTableViewCell
      
      cell.viewController = self
      cell.indexPath = indexPath
      
      let account = self.accounts[indexPath.row]
      
      cell.nameLabel.text = account.fullName
      cell.numberOfPointsLabel.text = "\(account.civilPoints)"
      
      return cell
   }
   
}
