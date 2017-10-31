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
      
      self.setupViewController()
      
      tempoCollection.append(Civilmaker.new(name: "Gleb", surname: "Kalachev"))
      tempoCollection.append(Civilmaker.new(name: "Vadim", surname: "Shemet"))
      tempoCollection.append(Civilmaker.new(name: "Alexey", surname: "Kalachev"))
      
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.observeUserChange(notification:)), name: userDataChangedNotificationName, object: nil)
      
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tempoCollection.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "civilmakerListTableViewCell", for: indexPath) as! CivilmakerListTableViewCell
      
      cell.setupOutlets(withCivilmaker: self.tempoCollection[indexPath.row])
      self.tempoCollection[indexPath.row].cellIndex = indexPath.row
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
      
      print("print of in-memory civilmakers:")
      for pair in self.tempoCollection.enumerated() {
         print("civilmaker#\(pair.offset).cellIndex: \(pair.element.cellIndex) ")
      }
      
   }
   
   @IBAction func addCMButtonTapped(_ sender: UIBarButtonItem) {
      
      CivilmakerDataManager.fetchCivilmakers { (fetchedCollection)  in
         
         self.tempoCollection = fetchedCollection
         DispatchQueue.main.async {
            self.tableView.reloadData()
         }
      }
   }
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   
   
   
   //MARK: +++ Selectors
   
   @objc func observeUserChange(notification: Notification) {
      
      print("tempoCollection before reloading: \(self.tempoCollection)")
      
      DispatchQueue.main.async {
         self.tableView.reloadData()
      }
      
   }
   
   
   //MARK: +++ Custom functions
   
   
   func setupViewController() {
      
      //Добавляем наблюдателя за изменением пользователей
      
      
   }
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
   
}
