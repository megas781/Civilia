//
//  RegisterTableViewController.swift
//  Civilia_Simulator
//
//  Created by Gleb Kalachev on 9/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController {
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var nameAndSurnameTextFieldsStack: UIStackView!
   @IBOutlet weak var nicknameTextField: UITextField!
   
   
   //MARK: +++ Properties
   
   
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      performUIPreparing()
      
      
      
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of TableViewDelegate
   
   override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
      return false
   }
   
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   
   
   
   //MARK: +++ IBActions of changing value
   
   @IBAction func desiredNameSegmentedControlValuedChanged(_ sender: UISegmentedControl) {
      
      let durationConst = 0.2
      
      switch sender.selectedSegmentIndex {
      case 0:
         
         UIView.animate(withDuration: durationConst, animations: { 
            self.nicknameTextField.alpha = 0
         }, completion: { (bool) in
            self.nicknameTextField.isHidden = true
            
            //Устанавливаю альфу на всякий случай
            self.nameAndSurnameTextFieldsStack.alpha = 0
            self.nameAndSurnameTextFieldsStack.isHidden = false

            UIView.animate(withDuration: durationConst, animations: { 
               self.nameAndSurnameTextFieldsStack.alpha = 1
            })
         })
         
      case 1:
         
         UIView.animate(withDuration: durationConst, animations: { 
            self.nameAndSurnameTextFieldsStack.alpha = 0
         }, completion: { (bool) in
            self.nameAndSurnameTextFieldsStack.isHidden = true
            
            //Устанавливаю альфу на всякий случай
            self.nicknameTextField.alpha = 0
            self.nicknameTextField.isHidden = false
            
            UIView.animate(withDuration: durationConst, animations: { 
               self.nicknameTextField.alpha = 1
            })
         })
         
      default:
         fatalError("incorrect case of segmented control")
      }
      
   }
   
   
   
   //MARK: +++ Updating UI Functions
   
   func performUIPreparing() {
      tableView.allowsSelection = false
      
   }
   
   
   //MARK: +++ Selectors
   
   
   
   
   //MARK: +++ Custom functions
   
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
   
   
   
    
   
   
   
   
   
   
}
