//
//  ViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit



class MainViewController: UITableViewController {
   
   
   
   
   //MARK: +++ Outlets
   
   
   
   
   //MARK: +++ Properties
   
   var accounts: [Civilmaker] = []
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
//      self.navigationItem.leftBarButtonItem = editButtonItem
//      self.navigationItem.leftBarButtonItem!.tintColor = .white
      
      self.accounts = Civilmaker.getAccounts()
      
      if self.accounts.count == 0 {
         self.accounts = [
            Civilmaker.init(fullName: "Gleb Kalachev", civilpoints: 10)
         ]
      }
      
   }
   
   override func viewDidAppear(_ animated: Bool) {
      Civilmaker.save(accounts: self.accounts)
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   
   @IBAction func checkButtonTapped(_ sender: UIButton) {
      
      if let fetchedAccounts = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) {
         
         print("exists!")
         print("fetchedAccounts: \(fetchedAccounts)")
         
      } else {
         print("doesn't exist")
      }
      
   }
   
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   
   
   
   //MARK: +++ Selectors
   
   
   
   
   //MARK: +++ Custom functions
   
   
   
   
   //MARK: +++ Navigation methods
   
   @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
      
      guard let identifier = segue.identifier else {
         print("нет identifier'a | это не нормально")
         return
      }
      
      switch identifier {
      case "createUnwind":
         print("create button")
         
         let src = segue.source as! AddCMViewController
         
         guard let newCivilmaker = src.newCivilmaker else {
            fatalError("Пустой newCivilMaker")
         }
         
         //TODO: Сделать анимацию добвления
         
         self.accounts.append(newCivilmaker)
         
         Civilmaker.save(accounts: self.accounts)
         
         self.tableView.reloadData()
         
         break
         
      case "cancelUnwind":
         
         print("cancelButton")
         break
         
      default:
         fatalError()
      }
   }
   
   
   
}

