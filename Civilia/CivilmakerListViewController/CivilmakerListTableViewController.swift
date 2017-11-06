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
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.observeUserChange(notification:)), name: userDataChangedNotificationName, object: nil)
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      //Загрузка списка цивилмейкеров при появлении CivilmakerList Scene
      CivilmakerDataManager.fetchCivilmakers { (fetched) in
         self.tempoCollection = fetched
         DispatchQueue.main.async {
            self.tableView.beginUpdates()
            for i in 0..<self.tempoCollection.count {
               self.tableView.insertRows(at: [IndexPath.init(row: i, section: 0)], with: UITableViewRowAnimation.top)
            }
            self.tableView.endUpdates()
         }
      }
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
   
   var k = 0
   @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
      
      print("back unwind tapped")
      self.performSegue(withIdentifier: "unwindFromCivilmakerListSceneToRegistrationSceneIdentifier", sender: self)
      
   }
   
   @IBAction func addCMButtonTapped(_ sender: UIBarButtonItem) {
      
      
      
   }
   @IBAction func publishButtonTapped(_ sender: UIButton) {
      
      Auth.auth().currentUser?.delete(completion: { (error) in
         
         Database.database().reference().child(FIRPrimeKey.users).setValue(nil)
         
      })
      
   }
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   
   
   
   //MARK: +++ Selectors
   
   //Метод, исполняющийся при изменении свойств у какого-либо из civilmaker'ов 
   @objc func observeUserChange(notification: Notification) {
      
      //Извлечение индекса ячейки, которую нужно перезагрузить
      guard let rowOfCellToReload = (notification.object as? Civilmaker)?.cellIndex else {
         print("couldn't retrieve rowOfCellToReload")
         return
      }
      DispatchQueue.main.async {
         self.tableView.reloadRows(at: [IndexPath.init(row: rowOfCellToReload, section: 0)], with: .left)
      }
      
   }
   
   
   //MARK: +++ Custom functions
   
   
   func setupViewController() {
      
      //Добавляем наблюдателя за изменением пользователей
      
      
   }
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
   
}
