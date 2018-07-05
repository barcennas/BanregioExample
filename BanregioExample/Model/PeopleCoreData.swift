//
//  PeopleCoreData.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 02/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PeoleCoreData {
    var id = ""
    var userId = ""
    var imagen: UIImage? = nil
    var name = ""
    var birthday = ""
    var address = ""
    
    init(data: NSManagedObject) {
        if let id = data.value(forKey: "id") as? String{
            self.id = id
        }
        if let userId = data.value(forKey: "userId") as? String{
            self.userId = userId
        }
        if let name = data.value(forKey: "name") as? String{
            self.name = name
        }
        if let birthday = data.value(forKey: "birthday") as? String{
            self.birthday = birthday
        }
        if let address = data.value(forKey: "address") as? String{
            self.address = address
        }
        if let imageData = data.value(forKey: "image") as? Data{
            self.imagen = UIImage(data: imageData)
        }
    }
}
