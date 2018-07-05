//
//  MapController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {

    @IBOutlet weak var mapaView: MKMapView!
    @IBOutlet weak var stackFooter: UIStackView!
    @IBOutlet weak var btnDrive: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    let locationManager = CLLocationManager()
    var userCoordinates: CLLocationCoordinate2D? = nil
    var placeCoordinates: CLLocationCoordinate2D? = nil
    var number: String? = nil
    var isMapCentered: Bool = false
    var branches: [Sucursal] = []
    var branchesFiltered: [Sucursal] = []
    var comesFromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setBranches(sucursales: branches)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getSucursales(){
        ApiHandler().getSucursales { (error, sucursales) in
            if error != nil {
                self.showMessage(message: error!.rawValue, backgroundColor: COLOR_ERROR, duration: 3, topStart: 0)
                return
            }else{
                self.branches = sucursales
                DispatchQueue.main.async {
                    self.setBranches(sucursales: sucursales)
                }
            }
        }
    }
    
    
    func configure(){
        
        if comesFromMenu {
            if navigationController != nil{
                let menuButton = UIBarButtonItem(image: UIImage(named: "icon_menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleBarButtonTap))
                self.navigationItem.setLeftBarButton(menuButton, animated: false)
            }
            getSucursales()
        }
        
        mapaView.delegate = self
        mapaView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setBranches(sucursales: [Sucursal]){
        removeAnnotations()
        for sucursal in sucursales{
            self.setAnnotation(sucursal: sucursal)
        }
    }
    
    func removeAnnotations(){
        mapaView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapaView.removeAnnotation($0)
            }
        }
    }
    
    func centerMap(){
        guard let userCoordinates = userCoordinates else {return}
        let region = MKCoordinateRegionMakeWithDistance(userCoordinates, 2000, 2000)
        mapaView.setRegion(region, animated: true)
        isMapCentered = true
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
        mapaView.addAnnotation(annotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        if let destination = segue.destination as? SearchController {
            destination.branches = self.branches
            destination.delegate = self
        }
        
    }
    
    @objc func handleBarButtonTap(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: SHOW_MENU), object: self)
    }

    @IBAction func btnSearchAction(_ sender: UIButton) {
        performSegue(withIdentifier: "MapToSearch", sender: nil)
    }
    
    @IBAction func btnCallAction(_ sender: UIButton) {
        guard let number = number else { return }
        guard let url = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnDriveAction(_ sender: UIButton) {
        
        guard let userCoordinates = userCoordinates else {return}
        guard let placeCoordinates = placeCoordinates else {return}
            
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinates))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: placeCoordinates))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapaView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapaView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    @IBAction func btnCenterMapAction(_ sender: UIButton) {
        centerMap()
    }
    
    @IBAction func btnFooterFilterAction(_ sender: UIButton) {
        guard let selectedOption = sender.titleLabel?.text else {return}
        mapaView.removeOverlays(mapaView.overlays)
        branchesFiltered = []
        
        if selectedOption == "Todos" {
            branchesFiltered = branches
        }else{
            branchesFiltered = branches.filter({$0.tipoCompleto == selectedOption})
        }
        setBranches(sucursales: branchesFiltered)
        
        
        for view in stackFooter.subviews {
            guard let btn = view as? UIButton else {continue}
            if sender == btn{
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = COLOR_BANREGIO
            }else{
                btn.setTitleColor(.black, for: .normal)
                btn.backgroundColor = .clear
            }
        }
    }
}

extension MapController: CLLocationManagerDelegate {
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

extension MapController: MKMapViewDelegate {
    
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
        mapView.setCenter(view.annotation!.coordinate, animated: true)
        
        placeCoordinates = customAnnotation.coordinate
        number = customAnnotation.telephone
        btnDrive.isHidden = false
        btnCall.isHidden = customAnnotation.type == "S" ? false : true
        mapaView.removeOverlays(mapaView.overlays)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView.image = UIImage(named: "icon_pin")
            annotationView.centerOffset = CGPoint(x: 0, y: -annotationView.frame.height / 2)
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        
        view.image = UIImage(named: "icon_pin")
        placeCoordinates = nil
        btnDrive.isHidden = true
        btnCall.isHidden = true
        for subview in view.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = COLOR_POLYLINE
        return renderer
    }
}

extension MapController: SearchControllerDelegate{
    func didSelectOption(sucursal: Sucursal) {
        _ = navigationController?.popViewController(animated: true)
        mapaView.removeOverlays(mapaView.overlays)
        setBranches(sucursales: [sucursal])
        
        for annotation in mapaView.annotations {
            if annotation is MKUserLocation{
                continue
            }
            mapaView.setCenter(annotation.coordinate, animated: true)
        }
    }
}
