//
//  ApiHandler.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import SystemConfiguration

enum ApiError: String {
    case serverError = "Error del servidor"
    case responseError = "Error al convertir respuesta"
    case internetError = "No se cuenta con conexión a internet"
}

class ApiHandler {
    
    let baseURL = "http://json.banregio.io/"
    
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func getSucursales(onCompletion: @escaping (ApiError?, [Sucursal]) -> Void) {
        
        if isInternetAvailable(){
            if let baseURL = URL(string: baseURL + "sucursales") {
                print(baseURL)
                let request = URLRequest(url: baseURL)
                URLSession.shared.dataTask(with: request) {data, response, error in
                    if error != nil {
                        DispatchQueue.main.async {
                            print("error=\(error?.localizedDescription ?? "no description")")
                            onCompletion(.serverError,[])
                        }
                    }else{
                        if let data = data {
                            if let sucursalesArray = data.convertToArray() {
                                var sucursales: [Sucursal] = []
                                
                                for jsonSucursal in sucursalesArray{
                                    if let jsonSucursal = jsonSucursal as? [String:Any]{
                                        //print(jsonSucursal)
                                        let sucursal = Sucursal(json: jsonSucursal)
                                        sucursales.append(sucursal)
                                    }
                                }
                                onCompletion(nil, sucursales)
                            }else{
                                DispatchQueue.main.async {
                                    onCompletion(.responseError, [])
                                }
                            }
                        }
                    }
                    }.resume()
            }
        }else{
            DispatchQueue.main.async {
                onCompletion(.internetError,[])
            }
        }
    }
}
