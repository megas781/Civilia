//
//  RegisterTableViewController.swift
//  Civilia_Simulator
//
//  Created by Gleb Kalachev on 9/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController,UITextFieldDelegate {
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordFirstInputTextField: UITextField!
   @IBOutlet weak var passwordSecondInputTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var surnameTextField: UITextField!
   @IBOutlet weak var maleSegmentedControl: UISegmentedControl!
   
   @IBOutlet weak var registerButton: RoundedButton!
   
   @IBOutlet var primeViews: [UIView]!
   
   //MARK: +++ Properties
   
   //Свойство, показывающее, отображается ли клавиатура на экране
   private var keyboardIsDisplayed = false
   
   //Свойство-ссылка на активный textField
   private var activeTextField: UITextField?
   
   
   //MARK: +++ Computed Properties
   
   private var isMale: Bool {
      switch maleSegmentedControl.selectedSegmentIndex {
      case 0:
         return true
      case 1:
         return false
      default:
         fatalError("Index is out of segmened control bounds")
      }
   }
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupUI()
      
      
      
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of TableViewDelegate
   
   override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
      return false
   }
   
   
   //MARK: +++ Implementation of custom protocols
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      self.activeTextField = textField
   }
   
   
   
   //MARK: +++ IBActions of Tap
   
   @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
      print("register button tapped")
   }
   
   
   
   
   
   //MARK: +++ IBActions of changing value
   
   @IBAction func emailTextFieldTextChanged(_ sender: UITextField) {
   }
   @IBAction func passwordFirstInputTextFieldTextChanged(_ sender: UITextField) {
      
   }
   @IBAction func passwordSecondInputTextFieldTextChanged(_ sender: UITextField) {
      
   }
   @IBAction func nameTextFieldTextChanged(_ sender: UITextField) {
   }
   @IBAction func surnameTextFieldTextChanged(_ sender: UITextField) {
   }
   
   
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupUI() {
      tableView.allowsSelection = false
      
      registerButton.isEnabled = false
      
      //Подпись класса под уведомления о появлении и исчезновении клавиатуры
      NotificationCenter.default.addObserver(self, selector: #selector(self.putUpTableViewForKeyboardAppearing(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.putDownTableViewForKeyboardDisappearing(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      //Соединение textField'ов с primaryKeyTriggered, который меняет firstResponder
      emailTextField.addTarget(self, action: #selector(self.primaryKeyTriggered(_:)), for: UIControlEvents.primaryActionTriggered)
      passwordFirstInputTextField.addTarget(self, action: #selector(self.primaryKeyTriggered(_:)), for: UIControlEvents.primaryActionTriggered)
      passwordSecondInputTextField.addTarget(self, action: #selector(self.primaryKeyTriggered(_:)), for: UIControlEvents.primaryActionTriggered)
      nameTextField.addTarget(self, action: #selector(self.primaryKeyTriggered(_:)), for: UIControlEvents.primaryActionTriggered)
      surnameTextField.addTarget(self, action: #selector(self.primaryKeyTriggered(_:)), for: UIControlEvents.primaryActionTriggered)
      
      //Добавление tap recognizer'ов для фоновых view, чтобы при нажатии на них убиралась клавиатура
      for view in self.primeViews {
         let gr = UITapGestureRecognizer(target: self, action: #selector(self.resignAnyFirstResponder))
         view.addGestureRecognizer(gr)
      }
      
      //Здесь я добавляю кнопку "Назад" для navigationItem
      navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Назад", style: .plain, target: self, action: #selector(self.backButtonTapped))
      navigationItem.leftBarButtonItem!.tintColor = UIColor.white      
      
      self.emailTextField.delegate = self
      self.passwordFirstInputTextField.delegate = self
      self.passwordSecondInputTextField.delegate = self
      self.nameTextField.delegate = self
      self.surnameTextField.delegate = self
      
   }
   
   
   //MARK: +++ Selectors
   
   @objc func resignAnyFirstResponder() {
      
      self.emailTextField.resignFirstResponder()
      self.passwordFirstInputTextField.resignFirstResponder()
      self.passwordSecondInputTextField.resignFirstResponder()
      self.nameTextField.resignFirstResponder()
      self.surnameTextField.resignFirstResponder()
      
      tableView.setContentOffset(CGPoint.zero, animated: true)
      tableView.contentInset = UIEdgeInsets.zero
      
   }
   
   //Действие primaryKey для каждого textField
   @objc func primaryKeyTriggered(_ sender: UITextField) {
      switch sender.tag {
      case 1,2,3,4:
         (view.viewWithTag(sender.tag + 1)! as! UITextField).becomeFirstResponder()
      case 5:
         sender.resignFirstResponder()
      default:
         fatalError("[шибка тега]")
      }
   }
   
   //метод, понимающий scrollView, адоптируясь под появляющуюся клавиатуру
   @objc func putUpTableViewForKeyboardAppearing(_ notification: Notification) {
      
      guard keyboardIsDisplayed == false,
         let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {
            return
      }
      
      guard let textField = self.activeTextField else {
         print("couldn't retrieve activeTextField")
         return
      }
      
      
       
      let absoluteTextFieldCoordinates = textField.superview!.convert(textField.frame, to: self.view)
      print("absolute maxY: \(absoluteTextFieldCoordinates.maxY)")
      
      let delta = (absoluteTextFieldCoordinates.maxY + keyboardHeight) - self.view.frame.size.height
      
      print("delta : \(delta)")
      
      tableView.setContentOffset(CGPoint.init(x: 0, y: delta > 0 ? delta : 0), animated: true)
      tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: delta > 0 ? delta : 0, right: 0)
      
   }
   
   @objc func putDownTableViewForKeyboardDisappearing(_ notification: Notification) {
      self.resignAnyFirstResponder()
      self.keyboardIsDisplayed = false
   }
   
   @objc func backButtonTapped() {
      self.resignAnyFirstResponder()
      performSegue(withIdentifier: "unwindToLoginViewControllerSegue", sender: self)
   }
   
   
   
   
   //MARK: +++ Custom functions
   
   
   
   
   //MARK: +++ Navigation methods
   
   
   
   
}
