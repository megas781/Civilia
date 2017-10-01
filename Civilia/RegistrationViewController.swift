//
//  RegistrationViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 9/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate {
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var theScrollView: UIScrollView!
   
   
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordFirstInputTextField: UITextField!
   @IBOutlet weak var passwordSecondInputTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var surnameTextField: UITextField!
   @IBOutlet weak var maleSegmentedControl: UISegmentedControl!
   
   @IBOutlet weak var registerButton: RoundedButton!
   
   
   //View, cодержащий весь контент внутри scrollView
   @IBOutlet weak var relativeContentView: UIView!
   
   //View, являющиеся фоном, и нажатие на кторые скрывает клавиатуру
   @IBOutlet var primeViews: [UIView]!
   
   //Чекмарки, соответствующие своим textField'ам по формуле checkmarks[textField.tag-1]
   @IBOutlet var checkmarks: [UIImageView]!
   
   
   //MARK: +++ Properties
   
   //Свойство, показывающее, отображается ли клавиатура на экране
   private var keyboardIsDisplayed = false
   
   //Свойство-ссылка на активный textField
   private var activeTextField: UITextField?
   
   //Свойство, хранящее последнюю зафиксированную высоту клавиатуры
   private var keyboardHeight: CGFloat!
   
   //Для каждого массива правило одно правило. 0-ой элемент - таймер исчезновения знака, 1-ый элемент - таймер появления positive sign'a, 2-ой элемент – резервный таймер для negative sign
   private var textFieldTimers: [[Timer]] = []
   
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
      
      let aTimer = Timer.init(timeInterval: 1, repeats: false, block: {(_) in})
      aTimer.invalidate()
      print("count: \(self.textFieldTimers.count)")
      self.textFieldTimers = Array.init(repeating: [Timer.init(timeInterval: 1, repeats: false, block: {(_) in}),Timer.init(timeInterval: 1, repeats: false, block: {(_) in})], count: 2)
      
      print("count after: \(self.textFieldTimers.count)")
      
      
      
      
      
      setupUI()
      
      
      
      
   }
   
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of TableViewDelegate
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      self.activeTextField = textField
      return true
   }
   
   
   //MARK: +++ IBActions of Tap
   
   @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
      print("register button tapped")
   }
   
   
   
   
   
   //MARK: +++ IBActions of changing value
   
   //text-changed для каждого textField
   @IBAction func anyTextFieldTextChanged(_ sender: UITextField) {
      
      //      guard sender.isFirstResponder else {
      //         print("is not first responder")
      //         return
      //      }
      
      
      
      self.toggleCheckmark(forTextField: sender)
      
      switch sender.tag {
      case 1:
         
         
         
//         DispatchQueue.main.async {
//            
//            let checkmark = self.checkmarks[sender.tag - 1]
//            
//            self.textFieldTimers[sender.tag - 1][0].invalidate()
//            
//            if !sender.text!.isEmailAddress && checkmark.image == #imageLiteral(resourceName: "checkmark") {
//               self.textFieldTimers[sender.tag - 1][0] = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { (timer) in
//                  DispatchQueue.main.async {
//                     checkmark.animateDisappearing()
//                  }
//               })
//            }
//            
//            self.textFieldTimers[sender.tag - 1][1].invalidate()
//            if sender.text!.isEmailAddress && !(checkmark.image == #imageLiteral(resourceName: "checkmark")){
//               self.textFieldTimers[sender.tag - 1][1] = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
//                  DispatchQueue.main.async {
//                     checkmark.animateEmergence(withImage: #imageLiteral(resourceName: "checkmark"))
//                  }
//               })
//            }
//            
//         }
         
         break
      case 2:
         //first password input
         
         break
      case 3:
         //second password input
         
         break
      case 4:
         //given name text field
         
         break
      case 5:
         //family name text field
         
         break
      default:
         fatalError("tag is out of cases")
      }
   }
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupUI() {
      
      registerButton.isEnabled = false
      
      //      self.navigationItem.titleView!.frame.size.width = self.view.frame.width
      
      //Подпись класса под уведомления о появлении и исчезновении клавиатуры
      NotificationCenter.default.addObserver(self, selector: #selector(self.putUpScrollViewForKeyboardAppearing(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      //      NotificationCenter.default.addObserver(self, selector: #selector(self.putDownScrollViewForKeyboardDisappearing(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
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
   
   
   
   //Действие primaryKey для каждого textField
   @objc func primaryKeyTriggered(_ sender: UITextField) {
      switch sender.tag {
      case 1,2,3,4:
         (view.viewWithTag(sender.tag + 1)! as! UITextField).becomeFirstResponder()
      case 5:
         self.resignAnyFirstResponder()
      default:
         fatalError("[ошибка тега]")
      }
   }
   
   //метод, понимающий scrollView, адоптируясь под появляющуюся клавиатуру
   @objc func putUpScrollViewForKeyboardAppearing(_ notification: Notification!) {
      
      //Если удалось извлечь, то сохраняем последнюю высоту в self.keyboardHeight
      guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {
         print("Не смог извлечь keyboardHeight")
         return
      }
      //      print("userInfo: \(notification.userInfo)")
      guard let textField = self.activeTextField else {
         print("Не смог извлечь activeTextField")
         return
      }
      
      print("keyboardHeight: \(keyboardHeight)")
      
      let absoluteTextFieldCoordinates = textField.superview!.convert(textField.frame, to: self.relativeContentView)
      print("absoluteCoordinates.maxY: \(absoluteTextFieldCoordinates.maxY)")
      let delta = (absoluteTextFieldCoordinates.maxY + keyboardHeight) - self.view.frame.size.height
      
      print("delta: \(delta)")
      
      
      UIView.animate(withDuration: 0.25, delay: 0, animations: { 
         self.theScrollView.contentOffset = CGPoint.init(x: 0, y: delta > 0 ? delta + 18 /*немного больше спейса над клавиатурой*/ : 0)
         self.theScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: delta > 0 ? delta + 18 /*немного больше спейса над клавиатурой*/ : 0, right: 0)
      })
      
      
      print()
   }
   
   @objc func resignAnyFirstResponder() {
      
      self.emailTextField.resignFirstResponder()
      self.passwordFirstInputTextField.resignFirstResponder()
      self.passwordSecondInputTextField.resignFirstResponder()
      self.nameTextField.resignFirstResponder()
      self.surnameTextField.resignFirstResponder()
      
      self.keyboardIsDisplayed = false
      self.activeTextField = nil
      
      UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: { 
         self.theScrollView.contentOffset = CGPoint.zero
         self.theScrollView.contentInset = UIEdgeInsets.zero
      })
      
   }
   
   
   @objc func backButtonTapped() {
      self.resignAnyFirstResponder()
      performSegue(withIdentifier: "unwindToLoginViewControllerSegue", sender: self)
   }
   
   var k = -1
   
   @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
      
      
      k += 1
      let checkmark = self.checkmarks[k % self.checkmarks.count]
      
      if checkmark.image == nil {
         checkmark.animateEmergence(withImage: #imageLiteral(resourceName: "checkmark"))
      } else {
         checkmark.animateChange(toImage: checkmark.image! == UIImage(named: "checkmark")! ? UIImage(named: "exclamation_mark")! : UIImage(named: "checkmark")!)
      }
      
      
   }
   
   
   
   //MARK: +++ Custom functions
   
   
   //
   private func toggleCheckmark(forTextField textField: UITextField) {
      
      
      DispatchQueue.main.async {
         
         let textFieldZeroBasedIndex = textField.tag - 1
         
         let checkmark = self.checkmarks[textFieldZeroBasedIndex]
         
         self.textFieldTimers[textFieldZeroBasedIndex][0].invalidate()
         
         if !textField.text!.isEmailAddress && checkmark.image == #imageLiteral(resourceName: "checkmark") {
            self.textFieldTimers[textFieldZeroBasedIndex][0] = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { (timer) in
               DispatchQueue.main.async {
                  checkmark.animateDisappearing()
               }
            })
         }
         
         self.textFieldTimers[textFieldZeroBasedIndex][1].invalidate()
         if textField.text!.isEmailAddress && !(checkmark.image == #imageLiteral(resourceName: "checkmark")){
            self.textFieldTimers[textFieldZeroBasedIndex][1] = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
               DispatchQueue.main.async {
                  checkmark.animateEmergence(withImage: #imageLiteral(resourceName: "checkmark"))
               }
            })
         }
         
      }
      
      
      
   }
   
}



//MARK: +++ Navigation methods




