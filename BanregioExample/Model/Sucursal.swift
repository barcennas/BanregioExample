//
//  Sucursal.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation

class Sucursal {
    var id = ""
    var tipo = ""
    var nombre = ""
    var domicilio = ""
    var horario = ""
    var telefonoPortal = ""
    var telefonoApp = ""
    var horas24 = ""
    var sabado = ""
    var ciudad = ""
    var estado = ""
    var latitud = ""
    var longitud = ""
    var correoGerente = ""
    var tipoCompleto = ""
    
    init(json: [String:Any]){
        if let id = json["ID"] as? String{
            self.id = id
        }
        if let tipo = json["tipo"] as? String{
            self.tipo = tipo
            if tipo == "S" {
                tipoCompleto = "Sucursales"
            }else{
                tipoCompleto = "Cajeros"
            }
        }
        if let nombre = json["NOMBRE"] as? String{
            self.nombre = nombre
        }
        if let domicilio = json["DOMICILIO"] as? String{
            self.domicilio = domicilio
        }
        if let horario = json["HORARIO"] as? String{
            self.horario = horario
        }
        if let telefonoPortal = json["TELEFONO_PORTAL"] as? String{
            self.telefonoPortal = telefonoPortal
        }
        if let telefonoApp = json["TELEFONO_APP"] as? String{
            self.telefonoApp = telefonoApp
        }
        if let horas24 = json["24_HORAS"] as? String{
            self.horas24 = horas24
        }
        if let sabado = json["SABADOS"] as? String{
            self.sabado = sabado
        }
        if let ciudad = json["CIUDAD"] as? String{
            self.ciudad = ciudad
        }
        if let estado = json["ESTADO"] as? String{
            self.estado = estado
        }
        if let latitud = json["Latitud"] as? String{
            self.latitud = latitud
        }
        if let longitud = json["Longitud"] as? String{
            self.longitud = longitud
        }
        if let correoGerente = json["Correo_Gerente"] as? String{
            self.correoGerente = correoGerente
        }
    }
}

