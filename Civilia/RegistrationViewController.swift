//
//  RegistrationViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 9/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
// 

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

let window = appDelegate.window!
class RegistrationViewController: UIViewController,UITextFieldDelegate {
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var theScrollView: UIScrollView!
   /*
    scrollViewBottomConstaint это vertical spacing scrollView к self.view . С помощью его константы мы будем поднимать нижную границу scroll'a.
    */
   @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
   
   
   @IBOutlet weak var emailTextField: VerifiableTextField!
   @IBOutlet weak var passwordFirstInputTextField: VerifiableTextField!
   @IBOutlet weak var passwordSecondInputTextField: VerifiableTextField!
   @IBOutlet weak var nameTextField: VerifiableTextField!
   @IBOutlet weak var surnameTextField: VerifiableTextField!
   
   //Здесь будут храниться вышеобъявленные textField'ы, только в формате словаря. Устанавливать сам словарь буду во viewDidLoad
   private var textFieldCollection: [Int : VerifiableTextField]!
   
   //Чекмарки, соответствующие своим textField'ам по формуле checkmarks[textField.tag-1]
   @IBOutlet var checkmarks: [CheckmarkView]!
   
   
   @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
   
   @IBOutlet weak var registerButton: RoundedButton!
   
   
   //View, cодержащий весь контент внутри scrollView
   @IBOutlet weak var relativeContentView: UIView!
   
   //View, являющиеся фоном, и нажатие на кторые скрывает клавиатуру
   @IBOutlet var primeViews: [UIView]!
   
   
   
   //MARK: +++ Properties
   
   //В этом свойстве хрянятся теги textField'ов, напротив которых есть checkmark. Тупо? На всякий случай, если будет поле, которое 
   private let verifiableTextFieldTags: [Int] = [1,2,3,4,5]
   
   //Свойство-ссылка на активный textField
   private var activeTextField: VerifiableTextField?
   
   //Свойство, хранящее последнюю зафиксированную высоту клавиатуры. Делаю опциональным и присваиваю ноль во viewDidLoad, чтобы сохранить логическое понимание переменной
   private var lastSavedKeyboardHeight: CGFloat = 0
   
   //Инструкция для каждого массива в textFieldTimers: 0-ой элемент - таймер исчезновения знака, 1-ый элемент - таймер появления positive sign'a, 2-ой элемент – резервный таймер для negative sign
   private var textFieldTimers: [Timer?] = []
   
   //Firebase needed properties
   var handler: AuthStateDidChangeListenerHandle?
   
   //MARK: +++ Computed Properties
   
   private var isMale: Bool {
      switch genderSegmentedControl.selectedSegmentIndex {
      case 0:
         return true
      case 1:
         return false
      default:
         fatalError("Index is out of segmened control bounds")
      }
   }
   
   //MARK: Firebase needed properties
   
   //Reference to the firebase database
   var ref: DatabaseReference!
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      
      setupViewController()
      
      //Здесь я задаю память для массива таймеров массивами из nil. На этот случай в toggleCheckmark метод .invalidate() я вызываю опционально. Это очень удобно))
      self.textFieldTimers = Array.init(repeating: nil, count: verifiableTextFieldTags.count)
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
         //Пока хз, что здесь делать
      })
      
      self.updateRegistrationButtonActivity()
      
   }
   
   
   override func viewWillDisappear(_ animated: Bool) {
      Auth.auth().removeStateDidChangeListener(handler!)
   }
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of TableViewDelegate
   
   
   
   
   //MARK: +++ UITextFieldDelegate Implementation
   
   
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
      if textField is VerifiableTextField {
         self.activeTextField = (textField as! VerifiableTextField)
      } else {
         fatalError("Ошибка downcasting'a параметра textField до VerifiableTextField")
      }
      
      return true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      
      //Это метод делегата, так что нужно роверять, является ли параметр VerifiableTextField
      //      if textField is VerifiableTextField {
      //         self.toggleCheckmark(forTextField: textField as! VerifiableTextField)
      //      }
      
   }
   
   //MARK: +++ IBActions of Tap
   
   @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
      
      let dimView = UIView.init(frame: window.frame)
      dimView.backgroundColor = .black
      dimView.alpha = 0.3
      
      let activityIndecator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
      activityIndecator.startAnimating()
      activityIndecator.center = dimView.center
      
      dimView.addSubview(activityIndecator)
      window.addSubview(dimView)
      
      
      Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordSecondInputTextField.text!) { (user, error) in
         //completion of auth
         
         defer {
            DispatchQueue.main.async {
               dimView.removeFromSuperview()
            }
         }
         
         //Если есть ошибка, то не нужно продолжать загружать
         guard error == nil else {
            
            //Создаем errorEnum, котороый удобно использовать для switch-конструкции
            guard let errorEnum = AuthErrorCode.init(rawValue: (error! as NSError).code) else {
               fatalError("Ошибка извлечения имени ошибки")
            }
            
            switch errorEnum {
            case .emailAlreadyInUse:
               self.showAlertController(withTitle: "Произошла ошибка", message: "Данная почта уже занята другим аккаунтом")
            default:
               self.showAlertController(withTitle: "Произошла ошибка", message: error!.localizedDescription)
               break
            }
            
            return
         }
         
         let newUser = Civilmaker.init(name: self.nameTextField!.text!, surname: self.surnameTextField!.text!, civilpoints: 0, dateOfCreation: Date(), image: nil, imageURL: nil)
         self.ref.child("uids").setValue(newUser.getDictionary())
         
         
         //Here I know, that there are no any errors, so I can go to another scene
         
         self.performSegue(withIdentifier: "fromRegistrationToMainSceneSegueIdentifier", sender: self)
         
      }
      
   }
   
   
   
   
   
   //MARK: +++ IBActions of changing value
   
   //text-changed для каждого textField
   @objc func anyTextFieldTextChanged(_ sender: UITextField) {
      
      /*
       Использую именно кастомный метод как селектор для textField'ов вместо метода делегата shouldChangeCharactersIn, потому что в этом методе значение строки sender.text уже измененное после нажатия кнопки на клавиатуре
       */
      
      if sender is VerifiableTextField {
         self.updateRegistrationButtonActivity()
         self.toggleCheckmark(forTextField: sender as! VerifiableTextField)
      }
      
   }
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupViewController() {
      
      registerButton.isEnabled = false
      
      self.ref = Database.database().reference()
      
      //      self.navigationItem.titleView!.frame.size.width = self.view.frame.width
      
      //Подпись класса под уведомления о появлении и исчезновении клавиатуры
      NotificationCenter.default.addObserver(self, selector: #selector(self.putUpScrollViewForAppearingKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      //            NotificationCenter.default.addObserver(self, selector: #selector(self.exampleSelector(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      
      //Устанавливаю textFieldCollection. Каждый ключ является тегом хранящегося под ним textField'a 
      self.textFieldCollection = [
         self.emailTextField.tag: self.emailTextField,
         self.passwordFirstInputTextField.tag:self.passwordFirstInputTextField,
         self.passwordSecondInputTextField.tag : self.passwordSecondInputTextField,
         self.nameTextField.tag: self.nameTextField,
         self.surnameTextField.tag : self.surnameTextField
      ]
      
      //Добавляю каждому
      for textField in self.textFieldCollection {
         textField.value.addTarget(self, action: #selector(self.primaryKeyTriggered(_:)), for: UIControlEvents.primaryActionTriggered)
         textField.value.addTarget(self, action: #selector(self.anyTextFieldTextChanged(_:)), for: UIControlEvents.editingChanged)
         textField.value.delegate = self
         textField.value.checkmark = self.checkmarks[textField.key - 1]
      }
      
      //Добавление tap recognizer'ов для фоновых view, чтобы при нажатии на них убиралась клавиатура
      for view in self.primeViews {
         let gr = UITapGestureRecognizer(target: self, action: #selector(self.resignAnyFirstResponder))
         view.addGestureRecognizer(gr)
      }
      
      //На углах segmentedControl'a белые углы. Поменяю цвет фона, но так как буквы тоже цвета фона, то положу под segmentedControl белый view
      do {
         
         genderSegmentedControl.layer.cornerRadius = genderSegmentedControl.frame.size.height/7
         
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
      
      //В этом методе производится простое переключение firstResponder'a. А toggling checkmark'ов проводится в textFieldDidEndEditing
      
      switch sender.tag {
      case 1,2,3,4:
         (view.viewWithTag(sender.tag + 1)! as! UITextField).becomeFirstResponder()
      case 5:
         self.resignAnyFirstResponder()
      default:
         fatalError("[ошибка тега]")
      }
      
      //      if verifiableTextFieldTags.contains(sender.tag) {
      //         self.toggleCheckmark(forTextField: sender)
      //      }
      
   }
   
   
   //метод, понимающий scrollView, адоптируясь под появляющуюся клавиатуру
   @objc func putUpScrollViewForAppearingKeyboard(_ notification: Notification?) {
      //print("putUpScrollViewForAppearingKeyboard performed")
      
      guard let retrievedTextField = activeTextField else {
         //print("не смог извлечь activeTextField")
         return
      }
      
      guard let endKeyboardRect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect) else {
         //print("не смог извлечь keyboardHeight")
         return
      }
      
      
      /*
       Важно! Сначала меняем size у scrollView, потом сам constraint, потому что в любом другом случае не будет анимации. scrollView будет менять свой размер мгновенно.
       */
      
      //Сначала поднимаю theScrollView...
      self.theScrollView.frame.size.height = endKeyboardRect.origin.y - 64
      //...после чего обновляю констрейнт
      self.scrollViewBottomConstraint.constant = (self.view.frame.size.height - (endKeyboardRect.origin.y - 64))
      
      //      //print(self.view.frame.size.height)
      //      //print(self.theScrollView.frame.maxY)
      //      //print("constrant: ", self.scrollViewBottomConstraint.constant)
      self.theScrollView.scrollRectToVisible(retrievedTextField.superview!.convert(retrievedTextField.frame, to: self.theScrollView), animated: true)
      
   }
   
   
   
   
   @objc func resignAnyFirstResponder() {
      
      self.emailTextField.resignFirstResponder()
      self.passwordFirstInputTextField.resignFirstResponder()
      self.passwordSecondInputTextField.resignFirstResponder()
      self.nameTextField.resignFirstResponder()
      self.surnameTextField.resignFirstResponder()
      
      //Этому свойству присваивается ложь только здесь
      //      self.keyboardIsDisplayed = false
      
      if let textField = self.activeTextField {
         if verifiableTextFieldTags.contains(textField.tag) {
            self.toggleCheckmark(forTextField: textField)
         }
      }
      
      self.activeTextField = nil
      
      
      UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { 
         
         self.theScrollView.frame.size.height = self.view.frame.size.height
         self.scrollViewBottomConstraint.constant = 0
         
      }) { (bool) in
         
         //         self.scrollViewButtomConstraint.isActive = true
      }
      
      
   }
   
   
   @objc func backButtonTapped() {
      self.resignAnyFirstResponder()
      performSegue(withIdentifier: "unwindToLoginViewControllerSegue", sender: self)
   }
   
   
   
   @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
      
      if let retrievedFrame = self.activeTextField?.frame {
         
         //print("scrollRect performed")
         
         self.theScrollView.scrollRectToVisible(retrievedFrame
            , animated: true)
         
      } else {
         //print("не удалось извлечь activeTextField")
      }
      
   }
   
   
   
   //MARK: +++ Custom functions
   
   //Это метод для обновления свойства isEnabled у registerButton. Исполняется в anyTextFieldValueChanged
   private func updateRegistrationButtonActivity() {
      
      //Если хоть что-то здесь равно nil или false, то свойству isEnabled присваиваеся false
      for textField in self.textFieldCollection.values {
         guard let isProperlyFilled = self.textFieldIsProperlyFilled(textField: textField),isProperlyFilled == true else {
            
            //Если до этого registerButton  была доступна, то производим анимацию затухания
            if self.registerButton.isEnabled {
               UIView.animate(withDuration: 0.2, delay: 0.5, animations: { 
                  self.registerButton.alpha = 0.4
               })
            }
            
            self.registerButton.isEnabled = false
            return
         }
      }
      
      //Если до этого registerButon была недоступна, то производим анимацию проявления цвета
      if !self.registerButton.isEnabled {
         UIView.animate(withDuration: 0.2, delay: 0.5, animations: { 
            self.registerButton.alpha = 1
         })
      }
      
      //На этом моменте все проверки пройдены, так что открываем registerButton
      self.registerButton.isEnabled = true
   }
   
   private func textFieldIsProperlyFilled(textField: VerifiableTextField) -> Bool? {
      
      var textFieldIsProperlyFilled: Bool!
      
      //В этой switch-конкструкции мы, собственно, и будем определять textFeildIsProperlyFilled
      switch textField.tag {
      case 1:
         //print("кейс email'a")
         textFieldIsProperlyFilled = textField.text!.isEmailAddress
      case 2:
         //print("кейс first password input")
         textFieldIsProperlyFilled = textField.text!.isPassword
      case 3:
         //print("кейс second password input")
         
         //Здесь нужно проверить, правильно ли заполнен firstInput перед тем, как оценивать правильность secondInput'a
         guard self.passwordFirstInputTextField.text!.isPassword else {
            //print("Первое поля пароля не заполнено, чтобы оценивать второе")
            
            //Если прежде у secondInputTextField'a стоял какой-то checkmark, то убираем его
            if textField.checkmark.image != nil {
               textField.checkmark.animateDisappearing()
            }
            
            return nil
         }
         
         textFieldIsProperlyFilled = self.passwordSecondInputTextField.text! == self.passwordFirstInputTextField.text!
      case 4:
         //Кейс nameTextField, т.е. Given Name
         textFieldIsProperlyFilled = textField.text!.isNameValid
      case 5:
         ////print("[case 5: Сделай имплементацию для фамилии!]")
         //Пока что разделяю 4 и 5 кейсы, если вдруг захочу разделить правила
         textFieldIsProperlyFilled = textField.text!.isNameValid
      default:
         fatalError("[НЕКОРРЕКТНОСТЬ_ИНДЕКСА: switch-конструкция попала в default при определении значения переменной textFieldIsProperlyFilled]")
      }
      
      return textFieldIsProperlyFilled
   }
   
   private func toggleCheckmark(forTextField textField: VerifiableTextField) {
      DispatchQueue.main.async {
         //         print("toggleCheckmark performed")
         //         guard self.verifiableTextFieldTags.contains(textField.tag) else {
         //            //print("[НЕКОРРЕКТНОСТЬ_ИНДЕКСА: тег textField'a (value: \(textField.tag)) вне релевантных значений verifiableTextFieldTags]")
         //            return
         //         }
         
         //Zero-based индекс textField'a, считающийся сверху вниз
         let textFieldZeroBasedIndex = textField.tag - 1
         
         //Ссылка на checkmark, соответствующий данному textField
         //         let checkmark = self.checkmarks[textFieldZeroBasedIndex]
         let checkmark = textField.checkmark!
         
         //Гарантированно обнуляем все предыдущие анимации, так как мы сейчас будем их в любом случае обновлять
         //         //print("textFieldTimers: \(self.textFieldTimers.count)")
         //         //print("textFieldTimers: \(self.textFieldTimers)")
         
         self.textFieldTimers[textFieldZeroBasedIndex]?.invalidate()
         self.textFieldTimers[textFieldZeroBasedIndex]?.invalidate()
         
         //по переменной textFieldIsProperlyFilled мы будем определять, правильно ли заполнен textField или нет. Для каждого textField будем делать свой кейс, определяющий, всё ли правильно 
         
         
         guard let textFieldIsProperlyFilled = self.textFieldIsProperlyFilled(textField: textField) else {
            print("textFieldIsProperly filled = nil, return from the function")
            return
         }
         
         if textField.isFirstResponder {
            
            //Анимация происходит только в случае, если при textField ,  
            if !textFieldIsProperlyFilled && checkmark.image != nil {
               self.textFieldTimers[textFieldZeroBasedIndex] = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { (timer) in
                  DispatchQueue.main.async {
                     checkmark.animateDisappearing()
                  }
               })
               //else-if гарантирует, что эти блоки кода, отвечающие за анимацию, не запустятся одновременно (хотя они и так не будут стакаться, так как оба выражения - это конъюнкции, и они имеют противоположные значения)
               
            } else if textFieldIsProperlyFilled && checkmark.status != CheckmarkView.CheckmarkStatus.positive {
               self.textFieldTimers[textFieldZeroBasedIndex] = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                  DispatchQueue.main.async {
                     checkmark.animateEmergence(withStatus: CheckmarkView.CheckmarkStatus.positive)
                  }
               })
            }
            
            //Здесь нам не нужно исполнять никакую анимацию
            
         } else {
            //Here we know, that textField is not first responder
            
            //If we resigned empty textField, it should assgin new image, describing, that user should fill it with a string
            guard textField.text != "" && textField.text != nil else {
               ////print("Здесь нужно сделать другой image, показывающий, что нужно заполнить поле")
               checkmark.animateDisappearing()
               return
            }
            
            
            //Здесь мы знаем, что checkmark'у точно нужно будет поставить какой-то image 
            
            
            //Используется properStatus, потому что если использовать тринарный оператор, вылетает ошибка Segmentation Fault 11
            var properStatus: CheckmarkView.CheckmarkStatus!
            if textFieldIsProperlyFilled {
               properStatus = CheckmarkView.CheckmarkStatus.positive
            } else {
               properStatus = CheckmarkView.CheckmarkStatus.negative
            }
            
            if checkmark.image == nil {
               checkmark.animateEmergence(withStatus: properStatus)
            } else {
               //Если то, какой статус нужно применить НЕ совпадает с текущим статусом, то производится анимация замены
               if checkmark.status != properStatus {
                  checkmark.animateChange(toStatus: properStatus)
               }
            }
            
         }
         
      }
   }
   
   //Удобная функция для создания AlerController'a
   private func showAlertController(withTitle title: String, message: String) {
      let ac = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
      ac.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
         //Пока ничего
      }))
      
      self.present(ac, animated: true) { 
         //Пока ничего
      }
   }
   
   //MARK: Navigation Methods
   
   @IBAction func unwindToRegistrationViewController(withSegue: UIStoryboardSegue) {
      print("unwind to registrationViewController preformed")
   }
   
}





