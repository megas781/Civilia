//
//  LoginViewController.swift
//  Civilia_Simulator
//
//  Created by Gleb Kalachev on 9/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   
   //MARK: +++ Outlets
   
   @IBOutlet weak var emailInputTextField: UITextField!
   @IBOutlet weak var passwordInputTextField: UITextField!
   
   @IBOutlet weak var theScrollView: UIScrollView!
   //Это outlet стака из кнопки регистрации и восстановления пароля. Этот outlet нужен, чтобы обозначить самую крайнюю точнку снизу
   @IBOutlet weak var theLowestView: UIView!
   
   //В этом массиве view собраны UIView, нажатие на которые вызывает putDownViewByKeyboardHeight(), чтобы убрать клавиатуру
   @IBOutlet var primeViews: [UIView]!
   
   
   //MARK: +++ Properties
   
   //Переменная, определяющая, отображается клавиатура или нет
   private var keyboardIsDisplayed = false
   
   
   //MARK: +++ Computed Properties
   
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      
      setupViewController()
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.putUpScrollViewForKeyboardAppearing(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.putDownScrollViewForKeyboardDisappearing), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
   }
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   
   
   
   //MARK: +++ Implementation of custom protocols
   
   
   
   
   //MARK: +++ IBActions on Tap
   
   @IBAction func enterButtonTapped(_ sender: UIButton) {
   }
   @IBAction func registraionButtonTapped(_ sender: UIButton) {
      performSegue(withIdentifier: "registrationButtonTappedSegue", sender: self)
   }
   @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
   }
   
   @IBAction func emailTextFieldNextButtonTapped(_ sender: UITextField) {
//      self.emailInputTextField.resignFirstResponder()
      self.passwordInputTextField.becomeFirstResponder()
   }
   @IBAction func passwordTextFieldNextButtonTapped(_ sender: UITextField) {
      self.perform(#selector(self.putDownScrollViewForKeyboardDisappearing))
   }
   
   
   
   
   //MARK: +++ IBActions on changing value
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupViewController() {
      
      for view in primeViews {
         let gr = UITapGestureRecognizer.init(target: self, action: #selector(self.resignAnyFirstResponder))
         view.addGestureRecognizer(gr)
      }
      
   }
   
   
   
   //MARK: +++ Selectors
   
   //Метод, убирающий contentInset и contentOffset для scrollView
   @objc func putUpScrollViewForKeyboardAppearing(_ notification: Notification) {
      
      
      guard !self.keyboardIsDisplayed else {
         return
      }
      
      
      guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {
         print("Ошибка извлечения информации из userInfo")
         return
      }
      
      
//      print("notificationType: \(notification.name)")
//      for infoPair in notification.userInfo! {
//         print("\(infoPair.key) : \(infoPair.value)")
//      }
//      print()
      
      
      let absoluteCoordinates = theLowestView.superview!.convert(theLowestView.frame, to: self.view)
      
      let theInset: CGFloat = absoluteCoordinates.maxY + keyboardHeight - UIScreen.main.bounds.height
      
      
      theScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: theInset, right: 0)
      theScrollView.setContentOffset(CGPoint.init(x: 0, y: theInset + (emailInputTextField.isFirstResponder ? 37 : 0)), animated: true)
      
      self.keyboardIsDisplayed = true
   }
   
   //Метод, убирающий contentInset и contentOffset для scrollView
   @objc func putDownScrollViewForKeyboardDisappearing() {
      guard self.keyboardIsDisplayed else {
         return
      }
      self.resignAnyFirstResponder()
      self.keyboardIsDisplayed = false
   }
   
   //Функция для скрытия клавиатуры
   @objc func resignAnyFirstResponder() {
      self.emailInputTextField.resignFirstResponder()
      self.passwordInputTextField.resignFirstResponder()
      theScrollView.setContentOffset(CGPoint.zero, animated: true)
      theScrollView.contentInset = UIEdgeInsets.zero
   }
   
   //MARK: +++ Custom functions
   
   
   
   
   //MARK: +++ Navigation methods
   
   @IBAction func unwindToLoginViewController(withSegue segue: UIStoryboardSegue) {}
   
   
   

}
