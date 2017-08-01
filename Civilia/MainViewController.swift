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
   
   //MARK: +++ Computed Properties
   
   var civilmakers: [Civilmaker] {
      get {
         //Я решил пока что всегда всё соритровать по количеству civilpoint'ов по убыванию(от большего вниз к меньшему)
         
         var returnArray: [Civilmaker] = self.civilmakerResults.map { (civilmaker) -> Civilmaker in
            return civilmaker
         }
         
         returnArray.sort { (one, two) -> Bool in
            return one.civilpoints > two.civilpoints
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
      
      try! realm.write {
         realm.add(Civilmaker.init(fullName: "Glib", civilpoints: 4))
         realm.add(Civilmaker.init(fullName: "Lexa", civilpoints: 8))
      }
      
      print("self.civilmakers before: \(civilmakers)")
      try! realm.write {
         for civilmaker in civilmakers {
            civilmaker.civilpoints += 1
         }
      }
      print("self.civilmakers after : \(civilmakers)")
      
      
      try! realm.write {
         realm.deleteAll()
      }
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
      self.navigationItem.leftBarButtonItem = editButtonItem
      self.publishButtonBackgourdRect.layer.cornerRadius = self.publishButtonBackgourdRect.frame.size.height/4
      self.navigationItem.leftBarButtonItem!.tintColor = .white
   }
   
   
   
   //MARK: +++ Selectors
   
   
   
   
   //MARK: +++ Custom functions
   
   
   
   //MARK: +++ Navigation methods
   
   @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
      
      
      
   }
   
   
   
}

