//
//  SearchCell.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(sucursal: Sucursal){
        lblHour.text = sucursal.tipo == "S" ? "Sucursal - \(sucursal.horario)" : "Cajero - 24 horas"
        lblName.text = sucursal.nombre
        lblAddress.text = sucursal.domicilio
    }
    
}
