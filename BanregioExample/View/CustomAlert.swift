//
//  CustomAlert.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import UIKit

protocol CustomAlertDelegate: class {
    func didTapOkButton()
}

protocol CustomAlertModal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

class CustomAlert: UIView, CustomAlertModal {
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    weak var delegate: CustomAlertDelegate?
    
    init(title:String, body:String, image:UIImage, isSucces: Bool) {
        super.init(frame: UIScreen.main.bounds)
        self.initialize(title: title, body: body, image: image, isSucces: isSucces)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title:String, body:String, image:UIImage, isSucces: Bool){
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-80
        var dialogViewHeight: CGFloat = 0.0
        
        let circularView = UIView(frame: CGRect(x: (dialogViewWidth / 2) - 50, y: -50, width: 100, height:100))
        circularView.backgroundColor = isSucces ? #colorLiteral(red: 0.5215686275, green: 0.7490196078, blue: 0.337254902, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        circularView.layer.cornerRadius = 50
        dialogView.addSubview(circularView)
        
        let imgViewIcon: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: (circularView.frame.width / 2) - 25, y: (circularView.frame.height / 2) - 25, width: 50, height: 50))
            imageView.image = image
            return imageView
        }()
        circularView.addSubview(imgViewIcon)
        
        dialogViewHeight += (circularView.frame.height / 2) + 20
        
        let lblTitle = UILabel(frame: CGRect(x: 20, y: dialogViewHeight, width: dialogViewWidth-40, height: 30))
        lblTitle.text = title
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont(name: "AvenirNext-Medium", size: 20)
        dialogView.addSubview(lblTitle)
        
        dialogViewHeight += lblTitle.frame.height + 10
        
        let lblBody = UILabel(frame: CGRect(x: 20, y: dialogViewHeight , width: dialogViewWidth-40, height: 80))
        lblBody.text = body
        lblBody.textAlignment = .center
        lblBody.font = UIFont(name: "AvenirNext-Regular", size: 17)
        lblBody.numberOfLines = 2
        lblBody.minimumScaleFactor = 0.5
        dialogView.addSubview(lblBody)
        
        dialogViewHeight += lblBody.frame.height + 20
        
        let btnDone: UIButton = {
            let button = UIButton(frame: CGRect(x: 30, y: dialogViewHeight, width: dialogViewWidth-60, height: 35))
            button.setTitle("OK", for: .normal)
            button.backgroundColor = isSucces ? #colorLiteral(red: 0.5215686275, green: 0.7490196078, blue: 0.337254902, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            button.layer.cornerRadius = 5
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOkButton)))
            return button
        }()
        dialogView.addSubview(btnDone)
        
        dialogViewHeight += btnDone.frame.height + 20
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = false
        addSubview(dialogView)
    }
    
    @objc func didTapOkButton(){
        delegate?.didTapOkButton()
        dismiss(animated: true)
    }
    
}
