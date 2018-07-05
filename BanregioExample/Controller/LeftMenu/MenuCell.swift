//
//  MenuCell.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(icon: UIImage, name: String){
        imgViewIcon.image = icon
        lblName.text = name
    }
    
}
