//
//  SplashscreenViewController.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit

class SplashscreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // background
        self.view.backgroundColor = .white
        
        // logo
        let logoImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        logoImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logo")
        self.view.addSubview(logoImageView)
        
        // show main screen after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.navigationController?.setViewControllers([MainViewController()], animated: true)
            
        }
        
    }
    
}
