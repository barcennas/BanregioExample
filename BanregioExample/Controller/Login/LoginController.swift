//
//  ViewController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit
import MapKit
import CoreData

enum iPhone: CGFloat {
    case iphoneSE = 568
    case iPhone8 = 667
    case IphoneX = 812
}

class LoginController: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var constViewTopHeight: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var userCoordinates: CLLocationCoordinate2D? = nil
    var isMapCentered: Bool = false
    var branches: [Sucursal] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = appDelegate.persistentContainer.viewContext
        
        hideKeyboardWhenTappedAround()
        configure()
        
        getSucursales()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsAlreadyLogged()
    }
    
    func checkIfUserIsAlreadyLogged(){
        if let encodedUser = UserDefaults.standard.data(forKey: USER_INFO) {
            if (NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? UserCoreData) != nil {
                performSegue(withIdentifier: "LoginToMainContainer", sender: nil)
                print("user was already logged")
            }
        }
    }
    
    func configure(){
        txtUser.delegate = self
        txtPassword.delegate = self
        
        txtUser.leftViewMode = .always
        txtUser.leftView = getTxtImageview(imageName: "icon_user_login")
        txtPassword.leftViewMode = .always
        txtPassword.leftView = getTxtImageview(imageName: "icon_lock_login")
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if iPhone.iphoneSE.rawValue == self.view.frame.height{
            print("App on iphone SE")
            constViewTopHeight.constant = 260
        }
        
    }
    
    func getTxtImageview(imageName: String) -> UIView{
        let imageView = UIImageView(frame: CGRect(x: 7, y: 7, width: 15, height: 15))
        imageView.image = UIImage(named: imageName)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.addSubview(imageView)
        return view
    }
    
    func centerMap(){
        guard let userCoordinates = userCoordinates else {return}
        let region = MKCoordinateRegionMakeWithDistance(userCoordinates, 2000, 2000)
        mapView.setRegion(region, animated: true)
        isMapCentered = true
    }
    
    func getSucursales(){
        ApiHandler().getSucursales { (error, sucursales) in
            if error != nil {
                self.showMessage(message: error!.rawValue, backgroundColor: COLOR_ERROR, duration: 3, topStart: 0)
                return
            }else{
                self.branches = sucursales
                for sucursal in sucursales{
                    self.setAnnotation(sucursal: sucursal)
                }
            }
        }
    }
    
    func setAnnotation(sucursal: Sucursal){
        guard let latitud = Double(sucursal.latitud) else {return}
        guard let longitud = Double(sucursal.longitud) else {return}
        let coordinates = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        
        let annotation = CustomAnnotation(coordinate: coordinates)
        annotation.coordinate = coordinates
        annotation.name = sucursal.nombre
        annotation.type = sucursal.tipo
        annotation.hours = sucursal.horario
        annotation.telephone = sucursal.telefonoApp
        mapView.addAnnotation(annotation)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        if let destination = segue.destination as? MapController {
            locationManager.stopUpdatingLocation()
            destination.branches = branches
        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        guard let user = txtUser.text, !user.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese su usuario")
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            showAlert(title: "Aviso", message: "Ingrese su contraseña")
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate1 = NSPredicate(format: "user = %@", user)
        let predicate2 = NSPredicate(format: "password = %@", password)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        request.predicate = compound
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if let usuarioData = result.first as? NSManagedObject{
                let userCoreD = UserCoreData(data: usuarioData)
                print("Name: \(userCoreD.name) id: \(userCoreD.id)")
                DispatchQueue.main.async {
                    let encodedUser = NSKeyedArchiver.archivedData(withRootObject: userCoreD)
                    UserDefaults.standard.set(encodedUser, forKey: USER_INFO)
                    self.performSegue(withIdentifier: "LoginToMainContainer", sender: nil)
                }
                
            }else{
                showAlert(title: "Aviso", message: "Usuario o contraseña incorrectos")
            }
        } catch {
            showMessage(message: "Ocurrió un error al obtener los usuarios, intente nuevamente", backgroundColor: COLOR_ERROR, duration: 3, topStart: 0)
        }
    }
    
    @IBAction func btnExpandMapAction(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToMap", sender: nil)
    }
    
    @IBAction func btnCenterMapAction(_ sender: UIButton) {
        centerMap()
    }
}

extension LoginController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        userCoordinates = userLocation.coordinate
        if !isMapCentered{
            centerMap()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
}

extension LoginController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation{
            return
        }

        let customAnnotation = view.annotation as! CustomAnnotation
        view.image = UIImage(named: "icon_pin_selected")
        let views = Bundle.main.loadNibNamed("CustomAnnotationView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomAnnotationView
        calloutView.lblSucursalTitulo.text = customAnnotation.type == "S" ? "Sucursal" : "Cajero"
        calloutView.lblSucursal.text = customAnnotation.name
        calloutView.lblHorario.text = customAnnotation.type == "S" ? customAnnotation.hours : "24 Horas"
        calloutView.lblTelefono.text = customAnnotation.type == "S" ? customAnnotation.telephone : "N/A"

        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        var coordinate = view.annotation!.coordinate
        coordinate.latitude += self.mapView.region.span.latitudeDelta * 0.35
        mapView.setCenter(coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView.image = UIImage(named: "icon_pin")
            annotationView.centerOffset = CGPoint(x: 0, y: -annotationView.frame.height / 2)
            annotationView.canShowCallout = false
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        
        view.image = UIImage(named: "icon_pin")
        for subview in view.subviews{
            subview.removeFromSuperview()
        }
    }
    
}
