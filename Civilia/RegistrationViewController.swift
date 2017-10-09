//
//  RegistrationViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 9/29/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit


let window = appDelegate.window!
class RegistrationViewController: UIViewController,UITextFieldDelegate {
   
   
   //MARK: +++ Outlets
   
   @IBOutlet weak var theScrollView: UIScrollView!
   
   
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordFirstInputTextField: UITextField!
   @IBOutlet weak var passwordSecondInputTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var surnameTextField: UITextField!
   @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
   
   @IBOutlet weak var registerButton: RoundedButton!
   
   
   //View, cодержащий весь контент внутри scrollView
   @IBOutlet weak var relativeContentView: UIView!
   
   //View, являющиеся фоном, и нажатие на кторые скрывает клавиатуру
   @IBOutlet var primeViews: [UIView]!
   
   //Чекмарки, соответствующие своим textField'ам по формуле checkmarks[textField.tag-1]
   @IBOutlet var checkmarks: [UIImageView]!
   
   
   //MARK: +++ Properties
   
   //Свойство, показывающее, отображается ли клавиатура на экране (removed)
   private var keyboardIsDisplayed = false
   
   
   //В этом свойстве хрянятся теги textField'ов, напротив которых есть checkmark
   private let verifiableTextFieldTags: [Int] = [1,2,3,4]
   
   //Свойство-ссылка на активный textField
   private var activeTextField: UITextField?
   
   //Свойство, хранящее последнюю зафиксированную высоту клавиатуры. Делаю опциональным и присваиваю ноль во viewDidLoad, чтобы сохранить логическое понимание переменной
   private var lastSavedKeyboardHeight: CGFloat = 0
   
   //Для каждого массива правило одно правило. 0-ой элемент - таймер исчезновения знака, 1-ый элемент - таймер появления positive sign'a, 2-ой элемент – резервный таймер для negative sign
   private var textFieldTimers: [[Timer?]] = []
   
   
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
   
   
   
   //MARK: +++ Overrides of Appearance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //Здесь я задаю память для массива таймеров массивами из nil. На этот случай в toggleCheckmark метод .invalidate() я вызываю опционально. Это очень удобно))
      self.textFieldTimers = Array.init(repeating: [nil,nil], count: verifiableTextFieldTags.count)
      
      
      setupUI()
      
      self.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
      
      
      
      
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      print("scrollView.frame: \(theScrollView.frame)")
      print(" self.view.frame: \(self.view.frame)")
      
      let view1 = UIView.init(frame: self.surnameTextField.superview!.convert(surnameTextField.frame, to: self.view))
      view1.frame.size = CGSize.init(width: 50, height: 34)
      view1.backgroundColor = UIColor.blue
      self.view.addSubview(view1)
      
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
      
      
      
      self.toggleCheckmark(forTextField: sender)
      
      
   }
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupUI() {
      
      registerButton.isEnabled = false
      
      //      self.navigationItem.titleView!.frame.size.width = self.view.frame.width
      
      //Подпись класса под уведомления о появлении и исчезновении клавиатуры
      NotificationCenter.default.addObserver(self, selector: #selector(self.alternativePutUpScrollViewForAppearingKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      //            NotificationCenter.default.addObserver(self, selector: #selector(self.exampleSelector(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
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
      switch sender.tag {
      case 1,2,3,4:
         (view.viewWithTag(sender.tag + 1)! as! UITextField).becomeFirstResponder()
         
         //На этом месте self.activeTextField будет уже переопределен, так что можно вызывать putUpScrollViewForKeyboardAppearing(), чтобы отрегулировать поднятие scrollView при нажатии на Next на клавиатуре
         //         self.alternativePutUpScrollViewForAppearingKeyboard(nil)
         
      case 5:
         self.resignAnyFirstResponder()
      default:
         fatalError("[ошибка тега]")
      }
      
      if verifiableTextFieldTags.contains(sender.tag) {
         self.toggleCheckmark(forTextField: sender)
      }
      
   }
   
   @objc func alternativePutUpScrollViewForAppearingKeyboard(_ notification: Notification?) {
      
      for pair in notification!.userInfo! {
         print("\(pair.key) : \(pair.value)")
      }
      
      
      //Конечный frame keyboard'a. У него мы будем использовать Y для поднятия scrollView (непосредственно theScrollView.frame).
      guard let endKeyboardRect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect) else {
         
         print("не смог извлечь keyboardHeight")
         return
      }
      print("retrieved y: \(endKeyboardRect.origin.y)")
      print()
      //Извлекаем активный textField. После, нам понадобится его frame
      guard let retrievedTextField = activeTextField else {
         print("не смог извлечь activeTextField")
         return
      }
      
      
      self.theScrollView.frame.size.height = endKeyboardRect.origin.y - (self.navigationController!.navigationBar.frame.size.height + 20) /* это высота status bar'a */
      self.theScrollView.scrollRectToVisible(retrievedTextField.superview!.convert(retrievedTextField.frame, to: self.theScrollView), animated: true)
      
   }
   
   //метод, понимающий scrollView, адоптируясь под появляющуюся клавиатуру
   @objc func putUpScrollViewForAppearingKeyboard(_ notification: Notification?) {
      
      print()
      for pair in notification!.userInfo! {
         print("\(pair.key) : \(pair.value)")
      }
      print()
      
      //В этой переменной будет храниться высота клавиатуры
      var keyboardHeight: CGFloat!
      
      //Удается ли извлечь высоту из userInfo?
      if let retrievedHeight = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height {
         //         print("case userInfo")
         //Если да, то устанавливаем извлеченное значение в keyboardHeight
         keyboardHeight = retrievedHeight
         
         //Здесь, если извлеченное значение больше текущего сохраненного (по дефолту хранится ноль), то обновляем его
         //         if self.largestSavedKeyboardHeight < retrievedHeight {
         self.lastSavedKeyboardHeight = retrievedHeight
         //         }
         
      } else
         //В противном случае, если нам удалось извлечь высоту из self.largestSavedKeyboardHeight(а если эта переменная равна нулю, то не смогли), то... 
         if self.lastSavedKeyboardHeight > 0 {
            //...то просто устанавливаем это значение в keyboardHeight
            //            print("case largestSavedKeyboardheight")
            keyboardHeight = self.lastSavedKeyboardHeight
         } else {
            //В самом противном случае, если мы вообще ничего не смогли извлечь, то выходим из функции, так как больше здесь нам делать нечего. Эта функция только поднимет scrollView на рассчитанную delta
            //         print("Не смог извлечь высоту клавиатуры ни из userInfo, ни из self.largestlargestSavedKeyboardHeight")
            return
      }
      
      
      //Извлечение activeTextField'a
      guard let textField = self.activeTextField else {
         print("Не смог извлечь activeTextField")
         return
      }
      
      
      //      print("self.view.frame.height  :\(self.view.frame.height)")
      let absoluteTextFieldCoordinates = textField.superview!.convert(textField.frame, to: self.view)
      //      print("absoluteCoordinates.maxY: \(absoluteTextFieldCoordinates.maxY)")
      //      print("local keyboardHeight    : \(keyboardHeight)")
      
      //      let delta = (absoluteTextFieldCoordinates.maxY + keyboardHeight) - self.view.frame.size.height
      let delta = keyboardHeight - (self.view.frame.size.height - absoluteTextFieldCoordinates.maxY)
      
      //      print("delta: \(delta)")
      
      
      
      
      //      UIView.animate(withDuration: 0.25, delay: 0, animations: { 
      //         self.theScrollView.contentOffset = CGPoint.init(x: 0, y: delta > 0 ? delta /*немного больше спейса над клавиатурой*/ : 0)
      //         self.theScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: delta > 0 ? delta /*немного больше спейса над клавиатурой*/ : 0, right: 0)
      //      })
      
      
      self.theScrollView.contentOffset = CGPoint.init(x: 0, y: 253)
      self.theScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 253, right: 0)
      
   }
   
   @objc func resignAnyFirstResponder() {
      
      self.emailTextField.resignFirstResponder()
      self.passwordFirstInputTextField.resignFirstResponder()
      self.passwordSecondInputTextField.resignFirstResponder()
      self.nameTextField.resignFirstResponder()
      self.surnameTextField.resignFirstResponder()
      
      //Этому свойству присваивается ложь только здесь
      self.keyboardIsDisplayed = false
      
      if let textField = self.activeTextField {
         if verifiableTextFieldTags.contains(textField.tag) {
            self.toggleCheckmark(forTextField: textField)
         }
      }
      
      self.activeTextField = nil
      //FIXME: Это нужно поменять на откат к преждему состоянию. И эта логика должна находиться не здесь, а где-нибудь в putDownScrollView
      
      print("this you will assign you scrollViewHeight: \(self.view.frame.size)")
      UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: { 
         
         self.theScrollView.frame.size = self.view.frame.size
         
      }) { (bool) in
         
      }
      
   }
   
   
   @objc func backButtonTapped() {
      self.resignAnyFirstResponder()
      performSegue(withIdentifier: "unwindToLoginViewControllerSegue", sender: self)
   }
   
   var k = -1
   
   @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
      
      if let retrievedFrame = self.activeTextField?.frame {
         
         print("scrollRect performed")
         
         self.theScrollView.scrollRectToVisible(retrievedFrame
            , animated: true)
         
      } else {
         print("не удалось извлечь activeTextField")
      }
      
   }
   
   
   
   //MARK: +++ Custom functions
   
   
   //
   private func toggleCheckmark(forTextField textField: UITextField) {
      DispatchQueue.main.async {
         
         guard self.verifiableTextFieldTags.contains(textField.tag) else {
            print("[НЕКОРРЕКТНОСТЬ_ИНДЕКСА: тег textField'a (value: \(textField.tag)) вне релевантных значений verifiableTextFieldTags]")
            return
         }
         
         //Zero-based индекс textField'a, считающийся сверху вниз
         let textFieldZeroBasedIndex = textField.tag - 1
         
         //Ссылка на checkmark, соответствующий данному textField
         let checkmark = self.checkmarks[textFieldZeroBasedIndex]
         
         //Гарантированно обнуляем все предыдущие анимации, так как мы сейчас будем их в любом случае обновлять
         //         print("textFieldTimers: \(self.textFieldTimers.count)")
         //         print("textFieldTimers: \(self.textFieldTimers)")
         
         self.textFieldTimers[textFieldZeroBasedIndex][0]?.invalidate()
         self.textFieldTimers[textFieldZeroBasedIndex][1]?.invalidate()
         
         //по переменной textFieldIsProperlyFilled мы будем определять, правильно ли заполнен textField или нет. Для каждого textField будем делать свой кейс, определяющий, всё ли правильно 
         var textFieldIsProperlyFilled: Bool!
         
         //В этой switch-конкструкции мы, собственно, и будем определять textFeildIsProperlyFilled
         switch textField.tag {
         case 1:
            print("кейс email'a")
            textFieldIsProperlyFilled = textField.text!.isEmailAddress
         case 2:
            print("кейс first password input")
            textFieldIsProperlyFilled = textField.text!.isPassword
         case 3:
            print("кейс second password input")
            
            //Здесь нужно проверить, правильно ли заполнен firstInput перед тем, как оценивать правильность secondInput'a
            guard self.passwordFirstInputTextField.text!.isPassword else {
               print("Первое поля пароля не заполнено, чтобы оценивать второе")
               
               //Если прежде у secondInputTextField'a стоял какой-то checkmark, то убираем его
               if checkmark.image != nil {
                  checkmark.animateDisappearing()
               }
               
               return
            }
            
            textFieldIsProperlyFilled = self.passwordSecondInputTextField.text! == self.passwordFirstInputTextField.text!
         case 4:
            //Кейс nameTextField, т.е. Given Name
            textFieldIsProperlyFilled = textField.text!.isNameValid
         default:
            fatalError("[НЕКОРРЕКТНОСТЬ_ИНДЕКСА: switch-конструкция попала в default при определении значения переменной textFieldIsProperlyFilled]")
         }
         
         if textField.isFirstResponder {
            
            
            //Анимация происходит только в случае, если при textField ,  
            if !textFieldIsProperlyFilled && checkmark.image != nil {
               self.textFieldTimers[textFieldZeroBasedIndex][0] = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { (timer) in
                  DispatchQueue.main.async {
                     checkmark.animateDisappearing()
                  }
               })
               //else-if гарантирует, что эти блоки кода, отвечающие за анимацию, не запустятся одновременно (хотя они и так не будут стакаться, так как оба выражения - это конъюнкции, и они имеют противоположные значения)
               
            } else if textFieldIsProperlyFilled && checkmark.image != #imageLiteral(resourceName: "checkmark") {
               self.textFieldTimers[textFieldZeroBasedIndex][1] = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                  DispatchQueue.main.async {
                     checkmark.animateEmergence(withImage: #imageLiteral(resourceName: "checkmark"))
                  }
               })
            }
            
            //Здесь нам не нужно исполнять никакую анимацию
            
         } else {
            //Here we know, that textField is not first responder
            
            //If we resigned empty textField, it should assgin new image, describing, that user should fill it with a string
            guard textField.text != "" && textField.text != nil else {
               print("Здесь нужно сделать другой image, показывающий, что нужно заполнить поле")
               checkmark.animateDisappearing()
               return
            }
            
            
            //Здесь мы знаем, что checkmark'у точно нужно будет поставить какой-то image 
            
            //В переменной properImage мы будем хранить релевантный image
            var properImage : UIImage!
            
            //Тринарный оператор, почему не работает. Выводит ошибку Segmentation Fault 11
            if textFieldIsProperlyFilled {
               properImage = UIImage(named:"checkmark")
            } else {
               properImage = UIImage(named:"exclamation_mark")
            }
            
            //Если текущий checkmark.image пустой, то...
            if checkmark.image == nil {
               //...то анимация появления
               checkmark.animateEmergence(withImage: properImage)
               
            } else {
               
               //Если у newImage, который нам нужно поставить, отличается от текущего checkmark.image'a, то мутим анимацию
               if checkmark.image != properImage {
                  checkmark.animateChange(toImage: properImage)
               }
            }
            
         }
         //         print()
         
      }
   }
   
}





