//
//  MenuViewController.swift
//  NetwO
//
//  Created by Alain Grange on 10/05/2021.
//

import UIKit

@objc protocol MenuViewControllerDelegate {
    @objc optional func menuSelectItem(sendViewController: MenuViewController, action: String)
}

class MenuViewController: UIViewController {
    
    let backgroundButton = UIButton()
    let contentView = UIView()
    
    var terminalMenu = false
    
    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background button
        backgroundButton.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backgroundButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        backgroundButton.backgroundColor = .black
        backgroundButton.alpha = 0.0
        self.view.addSubview(backgroundButton)
        
        // content view
        contentView.frame = CGRect(x: 20.0, y: 0.0, width: self.view.frame.size.width - 40.0, height: 0.0)
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = ColorGreyMedium
        contentView.alpha = 0.0
        self.view.addSubview(contentView)
        
        var yPosition: CGFloat = 20.0
        
        if terminalMenu {
        
            // debug button
            let debugButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
            debugButton.autoresizingMask = .flexibleWidth
            debugButton.addTarget(self, action: #selector(debugAction), for: .touchUpInside)
            debugButton.backgroundColor = ColorGreyLight
            debugButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            debugButton.setTitleColor(.white, for: .normal)
            debugButton.setTitle(NSLocalizedString("debug_mode", comment: ""), for: .normal)
            contentView.addSubview(debugButton)
            
            yPosition += debugButton.frame.size.height + 20.0
            
            // configuration button
            let configurationButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
            configurationButton.autoresizingMask = .flexibleWidth
            configurationButton.addTarget(self, action: #selector(configurationAction), for: .touchUpInside)
            configurationButton.backgroundColor = ColorGreyLight
            configurationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            configurationButton.setTitleColor(.white, for: .normal)
            configurationButton.setTitle(NSLocalizedString("configuration", comment: ""), for: .normal)
            contentView.addSubview(configurationButton)
            
            yPosition += configurationButton.frame.size.height + 20.0
            
            // report button
            let reportButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
            reportButton.autoresizingMask = .flexibleWidth
            reportButton.addTarget(self, action: #selector(reportAction), for: .touchUpInside)
            reportButton.backgroundColor = ColorGreyLight
            reportButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            reportButton.setTitleColor(.white, for: .normal)
            reportButton.setTitle(NSLocalizedString("envoi", comment: ""), for: .normal)
            contentView.addSubview(reportButton)
            
            yPosition += reportButton.frame.size.height + 20.0
            
            // scan ble button
            let scanBleButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
            scanBleButton.autoresizingMask = .flexibleWidth
            scanBleButton.addTarget(self, action: #selector(scanBleAction), for: .touchUpInside)
            scanBleButton.backgroundColor = ColorGreyLight
            scanBleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            scanBleButton.setTitleColor(.white, for: .normal)
            scanBleButton.setTitle(NSLocalizedString("scanBle", comment: ""), for: .normal)
            contentView.addSubview(scanBleButton)
            
            yPosition += scanBleButton.frame.size.height + 20.0
            
        }
        
        // online support button
        let onlineSupportButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
        onlineSupportButton.autoresizingMask = .flexibleWidth
        onlineSupportButton.addTarget(self, action: #selector(onlineSupportAction), for: .touchUpInside)
        onlineSupportButton.backgroundColor = ColorGreyLight
        onlineSupportButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        onlineSupportButton.setTitleColor(.white, for: .normal)
        onlineSupportButton.setTitle(NSLocalizedString("onlineSupport", comment: ""), for: .normal)
        contentView.addSubview(onlineSupportButton)
        
        yPosition += onlineSupportButton.frame.size.height + 20.0
        
        // about button
        let aboutButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
        aboutButton.autoresizingMask = .flexibleWidth
        aboutButton.addTarget(self, action: #selector(aboutAction), for: .touchUpInside)
        aboutButton.backgroundColor = ColorGreyLight
        aboutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        aboutButton.setTitleColor(.white, for: .normal)
        aboutButton.setTitle(NSLocalizedString("about", comment: ""), for: .normal)
        contentView.addSubview(aboutButton)
        
        yPosition += aboutButton.frame.size.height + 20.0
        
        // content view size
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: ((self.view.frame.size.height - yPosition) / 2.0), width: self.view.frame.size.width - 40.0, height: yPosition)
        contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.5
            self.contentView.alpha = 1.0

        }, completion: { (finished: Bool) in

        })
        
    }
    
    // MARK: - Actions
    
    @objc func closeAction() {
        dismissAction(action: nil)
    }
    
    @objc func dismissAction(action: String?) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.0
            self.contentView.alpha = 0.0

        }, completion: { (finished: Bool) in
            
            self.dismiss(animated: false) {
                
                if let actionString = action, actionString.count > 0 {
                    self.delegate?.menuSelectItem?(sendViewController: self, action: actionString)
                }
                
            }
            
        })
        
    }
    
    @objc func debugAction() {
        dismissAction(action: "debug")
    }
    
    @objc func configurationAction() {
        dismissAction(action: "configuration")
    }
    
    @objc func onlineSupportAction() {
        dismissAction(action: "onlineSupport")
    }
    
    @objc func aboutAction() {
        dismissAction(action: "about")
    }
    
    @objc func reportAction() {
        dismissAction(action: "report")
    }
    
    @objc func scanBleAction() {
        dismissAction(action: "scanBle")
    }
    
}
