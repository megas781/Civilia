//
//  AddCMViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class AddCMViewController: UIViewController {
   
   //MARK: Outlets
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var contentView: UIView!
   
   @IBOutlet weak var nameTextField: UITextField!
   
   @IBOutlet weak var civilpointsLabel: UITextField!
   
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   @IBOutlet weak var imageButton: UIButton!
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         let gr = UITapGestureRecognizer.init(target: self, action: #selector(self.didTapContentView(sender:)))
         self.contentView.addGestureRecognizer(gr)
      }
      
   }
   
   //Чтобы убирать клавиатуру
   func didTapContentView(sender: UITapGestureRecognizer) {
      print("didtapContentView executed")
      self.nameTextField.resignFirstResponder()
   }
   
   
   @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
      self.nameTextField.resignFirstResponder()
      
      //Здесь мы будем смотреть на выбранный сегмент и, в зависимости от него, будем презентовать тот или иной view
      
      
   }
   
   
   @IBAction func imageButtonTapped(sender: UIButton) {
      self.nameTextField.resignFirstResponder()
      
      //Здесь мы должны показать actionSheet с выбором imageSource
      
   }
   
   
   @IBAction func returnKeyTapped(_ sender: UITextField) {
      self.nameTextField.resignFirstResponder()
   }
   
   
}
