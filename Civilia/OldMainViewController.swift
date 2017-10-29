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

class OldMainViewController: UITableViewController {
   
   
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var publishButtonBackgourdRect: UIView!
   
   
   
   //MARK: +++ Properties
   
   private var realm: Realm!
   private var civilmakerResults: Results<Civilmaker>!
   
   var inMemoryCivilmakers: [Civilmaker] = []
   
   //MARK: +++ Computed Properties
   
   var computedCivilmakers: [Civilmaker] {
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
         //Инициализируем realm
         self.realm = try! Realm()
         //Fetch'им в civilmakerResults наши объекты
         self.civilmakerResults = realm.objects(Civilmaker.self)
         //Обновляем наш in-memory массив
         self.inMemoryCivilmakers = self.computedCivilmakers
      }
      
      setupUI()
      
   }
   
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   
   
   
   @IBAction func publishButtonTouchUpInside(_ sender: UIButton) {
      
      let ac = UIActivityViewController.init(activityItems: [self.computedCivilmakers.civilmakerStringStatistics], applicationActivities: nil)
      
      self.present(ac, animated: true, completion: nil)
      
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
   
   @objc func toggleEditingMode(sender: UIBarButtonItem) {
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
   
   func reloadData() {
      self.inMemoryCivilmakers = self.computedCivilmakers
      tableView.reloadData()
   }
   
   //MARK: +++ Navigation methods
   
   @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
      
      guard let identifier = segue.identifier else {
         fatalError("Сигвей без идентификатора")
      }
      
      switch identifier {
         
      case "createUnwind":
         let src = segue.source as! AddCMViewController
         
         guard let newCivilmaker = src.newCivilmaker else {
            fatalError("Couldn't retrieve the new civilmaker")
         }
         
         try! realm.write {
            realm.add(newCivilmaker)
         }
         self.reloadData()
         
      case "cancelUnwind":
         print("cancelUnwind executed")
         
      default:
         fatalError("Mustn't pass to default case")
      }
      
   }
   
   
   
}

