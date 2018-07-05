//
//  MainContainerController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class MainContainerController: UIViewController {

    @IBOutlet weak var constMenuLeading: NSLayoutConstraint!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var opcionesMenu: [(image: UIImage, name: String, closure: (MainContainerController)->())] = []
    var isMenuOpen = false
    var user: UserCoreData!
    var activeController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMenu.delegate = self
        tableMenu.dataSource = self
        tableMenu.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showMenu),
                                               name: NSNotification.Name(rawValue: SHOW_MENU),
                                               object: nil)
        getLoggedUser()
        configureMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (UserDefaults.standard.value(forKey: TUTORIAL_SEEN) as? Bool) == nil {
            openTutorial()
        }
    }
    
    func getLoggedUser(){
        if let encodedUser = UserDefaults.standard.data(forKey: USER_INFO) {
            if let loggedUser = NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? UserCoreData {
                self.user = loggedUser
            }
        }
    }
    
    func configureMenu(){
        
        imgUser.contentMode = .scaleToFill
        imgUser.image = self.user.image
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.clipsToBounds = true
        lblUserName.text = self.user.name
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        containerView.addGestureRecognizer(tapGesture)
        
        let homeClosure = { (vc: MainContainerController) in
            let newController = vc.storyboard?.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
            DispatchQueue.main.async {
                self.hideMenu()
                vc.removeInactiveViewController(inactiveViewController: self.activeController)
                vc.updateActiveViewController(newViewController: newController)
            }
        }
        
        let addUserClosure = { (vc: MainContainerController) in
            let newController = vc.storyboard?.instantiateViewController(withIdentifier: "RegisterPeopleNC") as! UINavigationController
            DispatchQueue.main.async {
                self.hideMenu()
                vc.removeInactiveViewController(inactiveViewController: self.activeController)
                vc.updateActiveViewController(newViewController: newController)
            }
        }
        
        let searchClosure = { (vc: MainContainerController) in
            let viewController = vc.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapController
            viewController.comesFromMenu = true
            let navController = UINavigationController(rootViewController: viewController)
            navController.navigationBar.barTintColor = COLOR_BANREGIO
            navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont(name: "Montserrat-SemiBold", size: 20)!, NSAttributedStringKey.foregroundColor : UIColor.white]
            navController.navigationBar.tintColor = .white
            navController.navigationBar.isTranslucent = false
            DispatchQueue.main.async {
                self.hideMenu()
                vc.removeInactiveViewController(inactiveViewController: self.activeController)
                vc.updateActiveViewController(newViewController: navController)
            }
        }

        
        let tutorialClosure = { (vc: MainContainerController) in
            DispatchQueue.main.async {
                if let tutorialPageVC = vc.storyboard?.instantiateViewController(withIdentifier: "TutorialPageVC") as? TutorialPageViewController {
                    self.hideMenu()
                    vc.present(tutorialPageVC, animated: true, completion: nil)
                }
            }
        }
        
        let logoutClosure = { (vc: MainContainerController) in
            DispatchQueue.main.async {
                UserDefaults.standard.set(nil, forKey: USER_INFO)
                vc.dismiss(animated: true, completion: nil)
            }
        }
        
        opcionesMenu.append((UIImage(named: "icon_menu_home")!, "Inicio", homeClosure))
        opcionesMenu.append((UIImage(named: "icon_menu_addPeople")!, "Agregar Persona", addUserClosure))
        opcionesMenu.append((UIImage(named: "icon_menu_search")!, "Buscar Sucursales", searchClosure))
        opcionesMenu.append((UIImage(named: "icon_menu_tutorial")!, "Tutorial", tutorialClosure))
        opcionesMenu.append((UIImage(named: "icon_menu_logout")!, "Cerrar sesión", logoutClosure))
        
        tableMenu.reloadData()
        
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        if isMenuOpen{
            hideMenu()
        }
    }

    func openTutorial(){
        if let tutorialPageVC = storyboard?.instantiateViewController(withIdentifier: "TutorialPageVC") as? TutorialPageViewController {
            hideMenu()
            self.present(tutorialPageVC, animated: true, completion: nil)
        }
    }
    
    @objc func showMenu(){
        isMenuOpen = true
        constMenuLeading.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideMenu(){
        constMenuLeading.constant = -240
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController) {
        print("VC Gone: ",inactiveViewController.description)
        inactiveViewController.willMove(toParentViewController: nil)
        inactiveViewController.view.removeFromSuperview()
        inactiveViewController.removeFromParentViewController()
    }
    
    private func updateActiveViewController(newViewController: UIViewController) {
        print("NEw VC : ",newViewController.description)
        addChildViewController(newViewController)
        newViewController.view.frame = containerView.bounds
        containerView.addSubview(newViewController.view)
        newViewController.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        activeController = segue.destination
    }
}

extension MainContainerController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < opcionesMenu.count-1 {
            let opcion = opcionesMenu[indexPath.row]
            let cell = tableMenu.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.configureCell(icon: opcion.image, name: opcion.name)
            return cell
        }else{
            if indexPath.row == 5 {
                let opcion = opcionesMenu.last!
                let cell = tableMenu.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
                cell.configureCell(icon: opcion.image, name: opcion.name)
                return cell
            }
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < opcionesMenu.count-1 {
            let opcion = opcionesMenu[indexPath.row]
            opcion.closure(self)
        }else if indexPath.row == 5{
            let opcion = opcionesMenu.last!
            opcion.closure(self)
        }
    }
    
    
}
