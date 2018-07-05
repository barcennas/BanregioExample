//
//  UserCell.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 02/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUser.layer.cornerRadius = 10
        imgUser.clipsToBounds = true
    }
    
    func configureCell(image: UIImage?, name: String, birthday: String, address: String){
        imgUser.image = image
        lblName.text = name
        lblBirthday.text = birthday
        lblAddress.text = address
    }
    
}
