//
//  TutorialStep.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import UIKit

class TutorialStep: NSObject {
    var index = 0
    var title = ""
    var content = ""
    var image : UIImage!
    
    init(index : Int, title: String, content : String, image: UIImage) {
        self.index = index
        self.title = title
        self.content = content
        self.image  = image
    }
    
}
