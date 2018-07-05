//
//  TutorialController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class TutorialController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnEndTutorial: UIButton!
    @IBOutlet weak var constHeightImage: NSLayoutConstraint!
    
    var tutorialStep: TutorialStep!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageHeight = iPhone.iphoneSE.rawValue == self.view.frame.height ? 180 : 240
        constHeightImage.constant = CGFloat(imageHeight)
        
        lblTitle.text = tutorialStep.title
        lblDescription.text = tutorialStep.content
        imgView.image = tutorialStep.image
        
        pageControl.currentPage = tutorialStep.index
        
        if tutorialStep.index == 2 {
            btnEndTutorial.isHidden = false
        }

    }

    @IBAction func btnEndTutorialAction(_ sender: UIButton) {
        print("Tutorial Ended")
        UserDefaults.standard.set(true, forKey: TUTORIAL_SEEN)
        self.dismiss(animated: true, completion: nil)
    }
}
