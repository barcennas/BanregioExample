//
//  CustomNavigationBar.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {

    override func awakeFromNib() {
        
        titleTextAttributes = [NSAttributedStringKey.font : UIFont(name: "Montserrat-SemiBold", size: 20)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        barTintColor = COLOR_BANREGIO
        
    }

}
