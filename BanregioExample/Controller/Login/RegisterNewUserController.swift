//
//  RegisterNewUserController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 02/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit
import CoreData

class RegisterNewUserController: UIViewController {
    
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUsuer: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnDeleteImage: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var userSelectedImage = false
    var imagePicker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    var entity: NSEntityDescription!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        imagePicker.delegate = self
        txtName.delegate = self
        txtUsuer.delegate = self
        txtPassword.delegate = self
        
        configure()
    }
    
    func configure(){
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
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func clearTextFields(){
        txtName.text = ""
        txtUsuer.text = ""
        txtPassword.text = ""
    }
    
    @IBAction func btnDeleteImageAction(_ sender: UIButton) {
        imgViewUser.contentMode = .center
        imgViewUser.image = UIImage(named: "icon_add_photo")
        userSelectedImage = false
        btnDeleteImage.isHidden = true
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
        guard let user = txtUsuer.text, !user.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese un usuario")
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese una contraseña")
            return
        }
        
        guard let photoData = UIImageJPEGRepresentation(userPhoto, 0.70) else {
            return
                showAlert(title: "Aviso", message: "Error al convertir la imagen, intente nuevamente")
        }
        
        let id = Int32(Date().timeIntervalSince1970)
        print("id of new user: ",id)
        let mainUserEntity = NSManagedObject(entity: entity, insertInto: context)
        mainUserEntity.setValue("\(id)", forKey: "id")
        mainUserEntity.setValue(name, forKey: "name")
        mainUserEntity.setValue(user, forKey: "user")
        mainUserEntity.setValue(password, forKey: "password")
        mainUserEntity.setValue(photoData, forKey: "image")
        
        do {
            try context.save()
            let customAlert = CustomAlert(title: "Exíto", body: "El usuario se guardo correctamente", image: UIImage(named: "icon_good")!, isSucces: true)
            customAlert.delegate = self
            customAlert.show(animated: true)
        } catch {
            let customAlert = CustomAlert(title: "Lo sentimos", body: "Sucedió un problema al guardar el usuario, intente nuevamente", image: UIImage(named: "icon_bad")!, isSucces: false)
            customAlert.show(animated: true)
            print("Failed saving: ", error.localizedDescription)
        }
        
    }
}

extension RegisterNewUserController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

extension RegisterNewUserController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtName {
            //64 height of navigation controller
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 70 : 0
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
        
        if textField == txtUsuer {
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 140 : 60
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
        
        if textField == txtPassword {
            let y = iPhone.iphoneSE.rawValue == (self.view.frame.height + 64) ? 150 : 80
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPassword {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterNewUserController: CustomAlertDelegate{
    func didTapOkButton() {
        _ = navigationController?.popViewController(animated: true)
    }
}
