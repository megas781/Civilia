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
   
   //Свойство, хранящее последнюю зафиксированную высоту клавиатуры. Делаю опциональным и присваиваю ноль во viewDidLoad, чтобы сохранить логическое понимание переменной
   private var lastSavedKeyboardHeight: CGFloat = 0
   
   //Для каждого массива правило одно правило. 0-ой элемент - таймер исчезновения знака, 1-ый элемент - таймер появления positive sign'a, 2-ой элемент – резервный таймер для negative sign
   private var textFieldTimers: [[Timer?]] = []
   
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

      //Здесь я задаю память для массива таймеров массивами из nil. На этот случай в toggleCheckmark метод .invalidate() я вызываю опционально. Это очень удобно))
      self.textFieldTimers = Array.init(repeating: [nil,nil], count: 3)
      
      
      
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
      
      
      
      self.toggleCheckmark(forTextField: sender)
      
      
   }
   
   
   
   
   //MARK: +++ Updating UI Functions
   
   func setupUI() {
      
      registerButton.isEnabled = false
      
      //      self.navigationItem.titleView!.frame.size.width = self.view.frame.width
      
      //Подпись класса под уведомления о появлении и исчезновении клавиатуры
      NotificationCenter.default.addObserver(self, selector: #selector(self.putUpScrollViewForKeyboardAppearing(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
         
         //На этом месте self.activeTextField будет уже переопределен, так что можно вызывать putUpScrollViewForKeyboardAppearing(), чтобы отрегулировать поднятие scrollView при нажатии на Next на клавиатуре
         self.putUpScrollViewForKeyboardAppearing(nil)
         
      case 5:
         self.resignAnyFirstResponder()
      default:
         fatalError("[ошибка тега]")
      }
      
      if (1...3).contains(sender.tag) {
         self.toggleCheckmark(forTextField: sender)
      }
      
   }
   
   //метод, понимающий scrollView, адоптируясь под появляющуюся клавиатуру
   @objc func putUpScrollViewForKeyboardAppearing(_ notification: Notification?) {
      
      //Если удалось извлечь, то сохраняем последнюю высоту в self.keyboardHeight
//      guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {
//         print("Не смог извлечь keyboardHeight из userInfo")
//         return
//      }
      
      //В этой переменной будет храниться высота клавиатуры
      var keyboardHeight: CGFloat!
      
      //Удается ли извлечь высоту из userInfo?
      if let retrievedHeight = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height {
         print("case userInfo")
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
            print("case largestSavedKeyboardheight")
         keyboardHeight = self.lastSavedKeyboardHeight
      } else {
            //В самом противном случае, если мы вообще ничего не смогли извлечь, то выходим из функции, так как больше здесь нам делать нечего. Эта функция только поднимет scrollView на рассчитанную delta
         print("Не смог извлечь высоту клавиатуры ни из userInfo, ни из self.largestlargestSavedKeyboardHeight")
         return
      }
      
      
      //Извлечение activeTextField'a
      guard let textField = self.activeTextField else {
         print("Не смог извлечь activeTextField")
         return
      }
      
      print("local keyboardHeight: \(keyboardHeight)")
      
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
      
      if let textField = self.activeTextField {
         if (1...3).contains(textField.tag) {
            self.toggleCheckmark(forTextField: textField)
         }
      }
      
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
         
         guard (1...3).contains(textField.tag) else {
            print("[НЕКОРРЕКТНОСТЬ_ИНДЕКСА: тег textField'a (value: \(textField.tag)) вне релевантных значений (1...3)]")
            return
         }
         
         //Zero-based индекс textField'a, считающийся сверху вниз
         let textFieldZeroBasedIndex = textField.tag - 1
         
         //Ссылка на checkmark, соответствующий данному textField
         let checkmark = self.checkmarks[textFieldZeroBasedIndex]
         
         //Гарантированно обнуляем все предыдущие анимации, так как мы сейчас будем их в любом случае обновлять
         print("textFieldTimers: \(self.textFieldTimers.count)")
         print("textFieldTimers: \(self.textFieldTimers)")
         
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
            
         } else {
            //Here we know, that textField is not first responder
            
            //If we resigned empty textField, it should assgin new image, describing, that user should fill it with a string
            guard textField.text != "" && textField.text != nil else {
               print("Здесь нужно сделать другой image, показывающий, что нужно заполнить поле")
               checkmark.animateDisappearing()
               return
            }
            
            
            //Здесь мы знаем, что checkmark'у точно нужно будет поставить какой-то image 
            
            var newImage : UIImage!
            
            if textFieldIsProperlyFilled {
               newImage = UIImage(named:"checkmark")
            } else {
               newImage = UIImage(named:"exclamation_mark")
            }
            
            
            
            if checkmark.image == nil {
               
               //Если текущий checkmark.image пустой, то анимация появления
               checkmark.animateEmergence(withImage: newImage)
               
            } else {
               
               //Если у newImage, который нам нужно поставить, отличается от текущего checkmark.image'a, то мутим анимацию
               if checkmark.image != newImage {
                  checkmark.animateChange(toImage: newImage)
               }
            }
            
         }
//         print()
         
      }
   }
   
}



//MARK: +++ Navigation methods




