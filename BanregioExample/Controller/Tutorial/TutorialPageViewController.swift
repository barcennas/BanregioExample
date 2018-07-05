//
//  TutorialPageViewController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    
    var tutorialSteps:[TutorialStep] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstStep = TutorialStep(index: 0, title: "Sucursales y Cajeros", content: "Encuentra las sucursales y cajeros mas cerca de ti y obtenen mas información al presionar en el pin sobre el mapa.", image: UIImage(named: "tutorial_1")!)
        tutorialSteps.append(firstStep)
        
        let secondStep = TutorialStep(index: 1, title: "Busqueda de Sucursales", content: "Realiza una busqueda de sucursales y cajeros escribiendo el nombre o el tipo (Cajero ó Sucursal)", image: UIImage(named: "tutorial_2")!)
        tutorialSteps.append(secondStep)
        
        let thirdStep = TutorialStep(index: 2, title: "Registro de Usuarios", content: "Agrega facilmente nuevos usuarios al llenar todos los campos y guardar", image: UIImage(named: "tutorial_3")!)
        tutorialSteps.append(thirdStep)

        dataSource = self
        if let startVC = self.pageViewController(atIndex: 0){
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
        
    }

}

extension TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialController).tutorialStep.index
        index += 1
        
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialController).tutorialStep.index
        index -= 1
        
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(atIndex : Int) -> TutorialController? {
        
        if atIndex == NSNotFound || atIndex < 0 || atIndex >= self.tutorialSteps.count{
            return nil
        }
        
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as? TutorialController{
            
            pageContentViewController.tutorialStep = self.tutorialSteps[atIndex]
            
            return pageContentViewController
        }
        
        return nil
        
    }
    
}
