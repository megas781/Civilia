//
//  ViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class MainViewController: UITableViewController {
   
   
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var publishButtonBackgourdRect: UIView!
   
   
   
   //MARK: +++ Properties
   
   private var realm: Realm!
   private var civilmakerResults: Results<Civilmaker>!
   
//   private var civilmakerNotificationToken: NotificationToken!
   
   //MARK: +++ Computed Properties
   
   var civilmakers: [Civilmaker] {
      get {
         
         var returnArray: [Civilmaker] = self.civilmakerResults.map { (civilmaker) -> Civilmaker in
            return civilmaker
         }
         
         returnArray.sort { (one, two) -> Bool in
            
            return one.dateOfCreation < two.dateOfCreation
         }
         
         return returnArray
      }
   }
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //Realm Setup
      do {
         self.realm = try! Realm()
         self.civilmakerResults = realm.objects(Civilmaker.self)
      }
      
      setupUI()
      
   }
   
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   @IBAction func publishButtonTapped(_ sender: UIButton) {
      
//      let ac = UIActivityViewController.init(activityItems: [self.accounts.civilmakerStringStatistics], applicationActivities: nil)
      
//      self.present(ac, animated: true, completion: nil)
      
   }
   
   
   
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupUI() {
      
      editButtonItem.action = #selector(self.toggleEditingMode(sender:))
      
      self.navigationItem.leftBarButtonItem = editButtonItem
      self.publishButtonBackgourdRect.layer.cornerRadius = self.publishButtonBackgourdRect.frame.size.height/4
      self.navigationItem.leftBarButtonItem!.tintColor = .white
   }
   
   
   
   //MARK: +++ Selectors
   
   func toggleEditingMode(sender: UIBarButtonItem) {
      tableView.setEditing(!tableView.isEditing, animated: true)
      if tableView.isEditing {
         sender.title = "Done"
         sender.style = .done
      } else {
         sender.title = "Edit"
         sender.style = .plain
      }
      
   }
   
   
   //MARK: +++ Custom functions
   
   
   
   //MARK: +++ Navigation methods
   
   @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
      
      
      
   }
   
   
   
}

