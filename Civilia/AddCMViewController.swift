//
//  AddCMViewController.swift
//  Civilia
//
//  Created by Gleb Kalachev on 7/14/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class AddCMViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
   
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
   
   var newCivilmaker: Civilmaker?
   
   
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
         
//         //Добавление gr для nameTextField
//         gr = UITapGestureRecognizer.init(target: self, action: #selector(self.nameTextFieldTouchUpInsude(sender:)))
//         self.nameTextField.addGestureRecognizer(gr)
      }
      
      self.civilpointsTextField.delegate = self
      
   }
   
   
   
   //MARK: +++ Overrides of Superclass
   
   
   
   
   //MARK: +++ Implementation of protocols
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      print("info: \(info)")
      
      
      
      if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
         
         
         
         self.imageButton.setImage(pickedImage, for: .normal)
         
      } else {
         print("провал с извлечением из info")
      }
      
      picker.dismiss(animated: true, completion: nil)
      
   }
   
   //Защита от того, чтобы в civilpointsTextField не появилось букв
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if ["0","1","2","3","4","5","6","7","8","9",""].contains(string) {
         return true
      } else {
         return false
      }
   }
   
   
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
      
      let ac = UIAlertController.init(title: "Choose source", message: "Where is the face of our new civilmaker?", preferredStyle: .actionSheet)
      
      let imagePicker = UIImagePickerController.init()
      
      imagePicker.delegate = self
      
      ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
      ac.addAction(.init(title: "Library", style: .default, handler: {
         (action) in
         //PhotoLibrary option
         
         imagePicker.sourceType = .photoLibrary
         
         self.present(imagePicker, animated: true, completion: nil)
         
      }))
      ac.addAction(.init(title: "Camera", style: .default, handler: {
         (action) in
         //Camera option
         
         imagePicker.sourceType = .camera
         
         self.present(imagePicker, animated: true, completion: nil)
         
      }))
      
      self.present(ac, animated: true, completion: nil)
      
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
   
   //nameTextField did become firt responder. Implemented to return zero to civilpointsTextFeild, if it is empty
   @IBAction func nameTextFieldTouchUpInside(_ sender: UITextField) {
      
      if self.civilpointsTextField.text == nil || self.civilpointsTextField.text == "" {
         self.civilpointsTextField.text = "0"
      }
      
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
      self.imageButton.layer.cornerRadius = self.imageButton.frame.size.height/36
      
      
      
      self.urlImageView.layer.borderColor = UIColor.black.cgColor
      self.urlImageView.layer.borderWidth = 2
      self.urlImageView.layer.cornerRadius = self.urlImageView.frame.size.height/36
      
      self.imageButton.imageView?.contentMode = .scaleAspectFill
      
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
      
      //Создаем civilmaker'a
      
      
      //TODO: FIX_IT
      guard let name = self.nameTextField.text,
         let civilpointsText = self.civilpointsTextField.text,
         let civilpoints = Int(civilpointsText) else {
            fatalError("Что-то не смог извлечь")
      }
      
      
      
      newCivilmaker = Civilmaker.init(fullName: name, civilpoints: civilpoints, dateOfCreation: Date(), image: self.imageButton.imageView?.image, imageURL: self.urlTextField.text == nil ? nil : URL(string: self.urlTextField.text!))
      
      
      self.performSegue(withIdentifier: "createUnwind", sender: self)
   }
   
   
   @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      self.performSegue(withIdentifier: "cancelUnwind", sender: self)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      self.resignAnyFirstResponder()
   }
    
}

fileprivate extension Civilmaker {
   convenience init(fullName: String, civilpoints: Int, dateOfCreation: Date, image: UIImage?, imageURL: URL?) {
      
      //Здесь использую инициализатор, чтобы установить id, так как в этом расширении у меня нет доступа к этому свойству
      self.init(fullName: fullName)
      
      self.civilpoints = civilpoints
      self.dateOfCreation = dateOfCreation
      self.image = image
      self.imageURL = imageURL
      
   }
}
