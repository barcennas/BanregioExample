//
//  Extensions.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import Foundation
import UIKit

extension CustomAlertModal where Self:UIView{
    func show(animated:Bool){
        self.backgroundView.alpha = 0
        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.addSubview(self)
        }
        
        
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                self.dialogView.center  = self.center
            })
        }else{
            self.backgroundView.alpha = 0.66
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: [], animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2 + 50)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
        
    }
}

extension Date {
    func substractYears(years: Int) -> Date{
        let resultDate = Calendar.current.date(byAdding: .year, value: -years, to: self)!
        return resultDate
    }
}

extension Data {
    func convertToDictionary() -> [String:Any]? {
        do {
            if let dict = try JSONSerialization.jsonObject(with: self) as? [String: Any] {
                return dict
            }
        } catch let parseError {
            print("convertToDictionary parsing error: \(parseError)")
            return nil
        }
        return nil
    }
    
    func convertToArray() -> [Any]? {
        do {
            if let array = try JSONSerialization.jsonObject(with: self) as? [Any] {
                return array
            }
        } catch let parseError {
            print("convertToArray parsing error: \(parseError)")
            return nil
        }
        return nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func showMessage(message: String, backgroundColor: UIColor, duration: TimeInterval, topStart: CGFloat = 64){
        //64
        let alertView = UIView(frame: CGRect(x: 0, y: topStart, width: self.view.frame.width, height: 1))
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        let lblDescripcion = UILabel()
        lblDescripcion.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(lblDescripcion)
        
        lblDescripcion.textColor = .white
        lblDescripcion.textAlignment = .center
        lblDescripcion.font = UIFont.systemFont(ofSize: 13)
        lblDescripcion.text = message
        lblDescripcion.numberOfLines = 2
        
        let leftConstntraint = NSLayoutConstraint(item: lblDescripcion, attribute: .leading, relatedBy: .equal, toItem: alertView, attribute: .leading, multiplier: 1, constant: 10)
        let rightConstntraint = NSLayoutConstraint(item: lblDescripcion, attribute: .trailing, relatedBy: .equal, toItem: alertView, attribute: .trailing, multiplier: 1, constant: -10)
        let yConstraint = NSLayoutConstraint(item: lblDescripcion, attribute: .centerY, relatedBy: .equal, toItem: alertView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leftConstntraint,rightConstntraint,yConstraint])
        
        self.view.addSubview(alertView)
        alertView.backgroundColor = backgroundColor
        
        let heightConstraintView = NSLayoutConstraint(item: alertView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        let widthConstraintView = NSLayoutConstraint(item: alertView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        let topConstntraintView = NSLayoutConstraint(item: alertView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: topStart)
        
        NSLayoutConstraint.activate([heightConstraintView, widthConstraintView,topConstntraintView])
        
        UIView.animate(withDuration: 0.3, animations: {
            heightConstraintView.constant = 25
            self.view.layoutIfNeeded()
        }) { (donde) in
            let when = DispatchTime.now() +  duration
            DispatchQueue.main.asyncAfter(deadline: when) {
                UIView.animate(withDuration: 0.3, animations: {
                    heightConstraintView.constant = 0
                    lblDescripcion.text = ""
                    self.view.layoutIfNeeded()
                }, completion: { _ in alertView.removeFromSuperview() })
            }
        }
        
    }
}
