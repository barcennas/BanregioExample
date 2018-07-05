//
//  User.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 02/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserCoreData: NSObject, NSCoding {
    var id = ""
    var image: UIImage? = nil
    var name = ""
    var user = ""
    var password = ""
    
    init(data: NSManagedObject) {
        if let id = data.value(forKey: "id") as? String{
            self.id = id
        }
        if let name = data.value(forKey: "name") as? String{
            self.name = name
        }
        if let user = data.value(forKey: "user") as? String{
            self.user = user
        }
        if let password = data.value(forKey: "password") as? String{
            self.password = password
        }
        if let imageData = data.value(forKey: "image") as? Data{
            self.image = UIImage(data: imageData)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let id = aDecoder.decodeObject(forKey: "id") as? String {
            self.id = id
        }
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let user = aDecoder.decodeObject(forKey: "user") as? String {
            self.user = user
        }
        if let password = aDecoder.decodeObject(forKey: "password") as? String {
            self.password = password
        }
        if let imagen = aDecoder.decodeObject(forKey: "image") as? UIImage {
            self.image = imagen
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.image, forKey: "image")
    }
}
