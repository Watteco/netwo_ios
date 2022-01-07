//
//  MainNavigationController.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit

class MainNavigationController: UINavigationController {

    var mainViewController: MainViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // status bar
        self.navigationBar.barStyle = .black;
        
        // background
        self.view.backgroundColor = UIColor.white
        
        // navigation bar color
        self.isNavigationBarHidden = true
        
        // root view controller
        if self.mainViewController == nil {
            self.mainViewController = MainViewController()
        }
        self.viewControllers = [mainViewController!]
        
    }

}
