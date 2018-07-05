//
//  RegisterUserController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit
import CoreData

class RegisterPeopleController: UIViewController {

    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtBirthDay: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnDeleteImage: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewPickerContainer: UIView!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    var userSelectedImage = false
    var imagePicker = UIImagePickerController()
    var formatter = DateFormatter()
    var user: UserCoreData!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    var userEntity: NSEntityDescription!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = appDelegate.persistentContainer.viewContext
        userEntity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        imagePicker.delegate = self
        txtName.delegate = self
        txtLastName.delegate = self
        txtBirthDay.delegate = self
        txtAddress.delegate = self
        
        getLoggedUser()
        configure()
    }
    
    func configure(){
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        birthdayPicker.minimumDate = Date().substractYears(years: 80)
        birthdayPicker.setValue(UIColor.white, forKeyPath: "textColor")
        birthdayPicker.locale = Locale(identifier: "es")
        
        imgViewUser.layer.cornerRadius = 10
        imgViewUser.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imgViewUser.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        if !userSelectedImage{
            let alert = UIAlertController(title: "Información", message: "Selecciona el metodo para cargar una imagen", preferredStyle: .actionSheet)
            
            let camaraAction = UIAlertAction(title: "Cámara", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }else{
                    self.showAlert(title: "Aviso", message: "Camara no dispinible")
                }
            }
            
            let carreteAction = UIAlertAction(title: "Carrete fotografico", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    self.imagePicker.sourceType = .photoLibrary;
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            
            alert.addAction(camaraAction)
            alert.addAction(carreteAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getLoggedUser(){
        if let encodedUser = UserDefaults.standard.data(forKey: USER_INFO) {
            if let loggedUser = NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? UserCoreData {
                self.user = loggedUser
            }
        }
    }
    
    func clearTextFields(){
        txtName.text = ""
        txtLastName.text = ""
        txtBirthDay.text = ""
        txtAddress.text = ""
        deleteImage()
    }
    
    func deleteImage(){
        imgViewUser.contentMode = .center
        imgViewUser.image = UIImage(named: "icon_add_photo")
        userSelectedImage = false
        btnDeleteImage.isHidden = true
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnOpenMenuAction(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SHOW_MENU), object: self)
    }
    
    @IBAction func btnDeleteImageAction(_ sender: UIButton) {
        deleteImage()
    }
    
    @IBAction func birthdayPickerValueChange(_ sender: UIDatePicker) {
        formatter.dateFormat = "dd-MM-yyyy"
        txtBirthDay.text = formatter.string(from: sender.date)
    }
    @IBAction func btnDonePickerAction(_ sender: UIButton) {
        viewPickerContainer.isHidden = true
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        guard let userPhoto = imgViewUser.image else {return}
        
        if !userSelectedImage {
            showAlert(title: "Aviso", message: "Agregue una foto de usted")
            return
        }
        
        guard let name = txtName.text, !name.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese su nombre")
            return
        }
        guard let lastName = txtLastName.text, !lastName.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese su apellido")
            return
        }
        guard let birthday = txtBirthDay.text, !birthday.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese su fecha de nacimiento")
            return
        }
        guard let address = txtAddress.text, !address.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese su dirección")
            return
        }
        
        guard let photoData = UIImageJPEGRepresentation(userPhoto, 0.70) else {
            return
             showAlert(title: "Aviso", message: "Error al convertir la imagen, intente nuevamente")
        }
        let id = Int32(Date().timeIntervalSince1970)
        print("UserId: ",user.id)
        let newUser = NSManagedObject(entity: userEntity, insertInto: context)
        newUser.setValue("\(id)", forKey: "id")
        newUser.setValue(user.id, forKey: "userId")
        newUser.setValue(name, forKey: "name")
        newUser.setValue(lastName, forKey: "lastName")
        newUser.setValue(birthday, forKey: "birthday")
        newUser.setValue(address, forKey: "address")
        newUser.setValue(photoData, forKey: "image")
        
        do {
            try context.save()
            clearTextFields()
            let customAlert = CustomAlert(title: "Exíto", body: "El usuario se guardo correctamente", image: UIImage(named: "icon_good")!, isSucces: true)
            customAlert.show(animated: true)
        } catch {
            let customAlert = CustomAlert(title: "Error", body: "Sucedió un problema al guardar el usuario, intente nuevamente", image: UIImage(named: "icon_bad")!, isSucces: false)
            customAlert.show(animated: true)
            print("Failed saving: ", error.localizedDescription)
        }
    }
}

extension RegisterPeopleController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let imagen = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgViewUser.contentMode = .scaleAspectFit
            imgViewUser.image = imagen
            userSelectedImage = true
            btnDeleteImage.isHidden = false
        }
    }
}

extension RegisterPeopleController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtName {
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 70 : 0
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
        
        if textField == txtLastName {
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 130 : 30
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
        
        if textField == txtBirthDay {
            txtLastName.resignFirstResponder()
            viewPickerContainer.isHidden = false
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 180 : 70
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            return false
        }

        if textField == txtAddress {
            viewPickerContainer.isHidden = true
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 190 : 80
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtAddress {
            scrollView.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





