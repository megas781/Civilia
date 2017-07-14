//
//  ViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

internal let archiveURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!

class MainViewController: UITableViewController {
   
   
   
   
   //MARK: +++ Outlets
   
   
   
   
   //MARK: +++ Properties
   
   var accounts: [Account] = []
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      accounts =  [
         
         Account.init(fullName: "Gleb Kalachev", civilPoints: 20),
         Account.init(fullName: "Vadim Shemet", civilPoints: 43),
         Account.init(fullName: "Ksenya Bondorenko", civilPoints: 13)
         
      ]
      
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   @IBAction func stepperValueChanged(_ stepper: UIStepper) {
      
      
      
   }
   
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   
   
   
   //MARK: +++ Selectors
   
   
   
   
   //MARK: +++ Custom functions
   
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
   
   
   
   
}

