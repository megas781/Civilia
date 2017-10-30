//
//  TemporaryViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CivilmakerListTableViewController: UITableViewController {
   
   
   
   //MARK: +++ Outlets
   
   
   
   
   //MARK: +++ Properties
   
   var tempoCollection: [Civilmaker] = []
   
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      
      tempoCollection.append(Civilmaker.init(name: "Gleb", surname: "Kalachev"))
      tempoCollection.append(Civilmaker.init(name: "Alexey", surname: "Kalachev"))
      
      for cm in tempoCollection {
//         Database.database().reference().child(FIRPrimeKeys.users).childByAutoId().setValue(cm.getDictionary())
      }
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.observeChanges(notification:)), name: NSNotification.Name.init("a civilmaker's data changed"), object: nil)
      
      
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tempoCollection.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "civilmakerListTableViewCell", for: indexPath) as! CivilmakerListTableViewCell
      
      cell.setupOutlets(withCivilmaker: self.tempoCollection[indexPath.row])
      cell.viewController = self
      cell.indexPath = indexPath
      
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
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
   
      
      //Пока что при нажатии на back button пользователь удаляется
      Auth.auth().currentUser?.delete(completion: { (error) in
         
         guard error == nil else {
            
            print("error occured: \(error!.localizedDescription)")
            
            return
         }
         
         DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "unwindFromMainCivilmakerListSceneToRegistrationSceneSegueIdentifier", sender: self)
            
         }
      })
      
   
   }
   
   @IBAction func addCMButtonTapped(_ sender: UIBarButtonItem) {
      
      
      
   }
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   
   
   
   //MARK: +++ Selectors
   
   @objc func observeChanges(notification: Notification) {
      
      print("observeChanges performed")
      DispatchQueue.main.async {
         self.tableView.reloadData()
      }
      
   }
   
   
   //MARK: +++ Custom functions
   
   
   func setupTestWithData() {
      
      
      
   }
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
   
}
