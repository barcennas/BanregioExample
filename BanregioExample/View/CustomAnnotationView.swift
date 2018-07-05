//
//  CustomAnnotationView.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class CustomAnnotationView: UIView {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblSucursalTitulo: UILabel!
    @IBOutlet weak var lblSucursal: UILabel!
    @IBOutlet weak var lblHorario: UILabel!
    @IBOutlet weak var lblTelefono: UILabel!
    
    override func awakeFromNib() {
        viewContainer.layer.cornerRadius = 5
    }

}
