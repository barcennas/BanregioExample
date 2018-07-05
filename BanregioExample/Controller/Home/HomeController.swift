//
//  HomeController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    @IBOutlet weak var tableUsuarios: UITableView!
    
    var usuarios: [PeoleCoreData] = []
    var user: UserCoreData!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableUsuarios.delegate = self
        tableUsuarios.dataSource = self
        
        context = appDelegate.persistentContainer.viewContext
        
        getLoggedUser()
        getPeople()
        if usuarios.isEmpty {
            tableUsuarios.isHidden = true
        }
    }
    
    func getPeople(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.predicate = NSPredicate(format: "userId = %@", user.id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let usuario = PeoleCoreData(data: data)
                print("id: \(usuario.id) userId: \(usuario.userId) , Name: \(usuario.name)")
                usuarios.append(usuario)
            }
        } catch {
            showMessage(message: "Ocurrió un error al obtener los usuarios, intente nuevamente", backgroundColor: COLOR_ERROR, duration: 3, topStart: 0)
        }
    }
    
    func getLoggedUser(){
        if let encodedUser = UserDefaults.standard.data(forKey: USER_INFO) {
            if let loggedUser = NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? UserCoreData {
                self.user = loggedUser
            }
        }
    }
    
    @IBAction func btnOpenMenuAction(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SHOW_MENU), object: self)
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usuario = usuarios[indexPath.row]
        
        let cell = tableUsuarios.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.configureCell(image: usuario.imagen, name: usuario.name, birthday: usuario.birthday, address: usuario.address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


