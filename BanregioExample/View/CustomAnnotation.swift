//
//  CustomAnnotation.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var type: String!
    var hours: String!
    var telephone: String!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
