//
//  AddCMViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class AddCMViewController: UIViewController {
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var contentView: UIView!
   
   @IBOutlet weak var nameTextField: UITextField!
   
   @IBOutlet weak var civilpointsTextField: UITextField!
   
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   @IBOutlet weak var imageButton: UIButton!
   
   @IBOutlet weak var urlViewContainer: UIView!
   @IBOutlet weak var urlTextField: UITextField!
   @IBOutlet weak var urlImageView: UIImageView!
   
   @IBOutlet weak var createButton: UIBarButtonItem!
   
   
   //MARK: +++ Properties
   
   
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.updateUI()
      
      //Добавление gestureRecognizer'ов
      do {
         //Хрупкая система переопределения gr
         
         //Добавление gr для contentView
         var gr = UITapGestureRecognizer.init(target: self, action: #selector(self.didTapContentView(sender:)))
         self.contentView.addGestureRecognizer(gr)
         
         //Добавление gr для segmentedControl
         gr = UITapGestureRecognizer.init(target: self, action: #selector(self.segmentedControlTapped(_:)))
         self.segmentedControl.addGestureRecognizer(gr)
      }
      
   }
   
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions of Tap
   
   //Это теперь селектор
   func segmentedControlTapped(_ sender: UITapGestureRecognizer) {
      self.resignAnyFirstResponder()
      
      //Здесь мы будем смотреть на выбранный сегмент и, в зависимости от него, будем презентовать тот или иной view
      
      
      //Алгоритм вычисления выделения segmentedControl'a, так как после добавления tap gesture recognizer'a он утратил эту функцию
      let segmentedControl = sender.view! as! UISegmentedControl /* Объявил перед do для последующего использования */
      do {
         if sender.location(in: segmentedControl).x < segmentedControl.frame.size.width/2 {
            segmentedControl.selectedSegmentIndex = 0
         } else {
            segmentedControl.selectedSegmentIndex = 1
         }
      }
      
      
      switch segmentedControl.selectedSegmentIndex {
      case 0:
         
         imageButton.isHidden = false
//         imageButton.isEnabled = true
         
         urlViewContainer.isHidden = true
//         urlTextField.isEnabled = false
         
         
      case 1:
         
         imageButton.isHidden = true
//         imageButton.isEnabled = false
         urlViewContainer.isHidden = false
         
         
      default:
         fatalError()
      }
      
   }
   
   
   @IBAction func imageButtonTapped(sender: UIButton) {
      self.resignAnyFirstResponder()
      
      //Здесь мы должны показать actionSheet с выбором imageSource
      
   }
   
   //Нажатие Return'a в nameTextField
   @IBAction func nameTextFieldReturnKeyTapped(_ sender: UITextField) {
      
      //Такое же условие, чтобы не переходил на civilpointsLabel, пока invalid fullName
      guard sender.text != nil && sender.text!.isVisible && sender.text!.characters.count > 2 else {
         print("недостаточное имя")
         createButton.isEnabled = false
         return
      }
      
      self.civilpointsTextField.text = ""
      self.civilpointsTextField.becomeFirstResponder()
   }
   
   //civipointstextField did become first responder
   //Чтобы убирать ноль
   @IBAction func civilpointsTextFieldTouchUpInside(_ sender: UITextField) {
      if sender.text == "0" {
         sender.text = ""
      }
   }
   
   
   //Нажатие Return'a в civilpointsTextField
   @IBAction func civilpointsTextFieldReturnButtonTapped(_ sender: UITextField) {
      self.resignAnyFirstResponder()
   }
   
   
   
   //MARK: +++ IBActions of changing value
   
   @IBAction func nameTextFieldValueChanged(_ sender: UITextField) {
      
      guard sender.text != nil && sender.text!.isVisible && sender.text!.characters.count > 2 else {
         print("недостаточное имя")
         createButton.isEnabled = false
         return
      }
      print("О, теперь норм")
      createButton.isEnabled = true
      
   }
   
   
   
   //MARK: +++ Updating UI Functions
   
   func updateUI() {
      self.imageButton.layer.borderColor = UIColor.black.cgColor
      self.imageButton.layer.borderWidth = 2
      
      self.urlImageView.layer.borderColor = UIColor.black.cgColor
      self.urlImageView.layer.borderWidth = 2
      
      
   }
   
   
   //MARK: +++ Selectors
   
   //Чтобы убирать клавиатуру
   func didTapContentView(sender: UITapGestureRecognizer) {
      self.resignAnyFirstResponder()
   }
   
   
   
   //MARK: +++ Custom functions
   func resignAnyFirstResponder() {
      self.nameTextField.resignFirstResponder()
      self.urlTextField.resignFirstResponder()
      self.civilpointsTextField.resignFirstResponder()
      if civilpointsTextField.text == "" || civilpointsTextField.text == nil {
         civilpointsTextField.text = "0"
      }
   }
   
   
   
   //MARK: +++ Navigation methods
   
   @IBAction func createButtonTapped(_ sender: UIBarButtonItem) {
      self.performSegue(withIdentifier: "createUnwind", sender: self)
   }
   
   
   @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      self.performSegue(withIdentifier: "cancelUnwind", sender: self)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      self.resignAnyFirstResponder()
   }
   
   
   
   
}
