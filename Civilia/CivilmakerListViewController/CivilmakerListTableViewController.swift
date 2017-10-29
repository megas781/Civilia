//
//  TemporaryViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 10/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import FirebaseAuth


class CivilmakerListTableViewController: UITableViewController {
   
   
   
   //MARK: +++ Outlets
   
   
   
   
   //MARK: +++ Properties
   
   
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
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
   
   
   
   //MARK: +++ IBActions of changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   
   
   
   //MARK: +++ Selectors
   
   
   
   
   //MARK: +++ Custom functions
   
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
   
}
