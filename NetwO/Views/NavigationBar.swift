//
//  NavigationBar.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit

@objc protocol NavigationBarDelegate {
    @objc optional func delete(navigationBar: NavigationBar)
    @objc optional func simple(navigationBar: NavigationBar)
    @objc optional func graphTx(navigationBar: NavigationBar)
    @objc optional func graphRx(navigationBar: NavigationBar)
    @objc optional func scan(navigationBar: NavigationBar)
    @objc optional func menu(navigationBar: NavigationBar)
}

class NavigationBar: UIView {

    let mainTitleLabel = UILabel()
    let deleteButton = UIButton()
    let simpleButton = UIButton()
    let graphTxButton = UIButton()
    let graphRxButton = UIButton()
    let scanButton = UIButton()
    
    var delegate: NavigationBarDelegate?
    
    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        var topMargin: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topMargin = window?.safeAreaInsets.top ?? 0.0
        }
        
        // background
        self.backgroundColor = ColorPrimary
        
        // main title label
        mainTitleLabel.frame = CGRect(x: 10.0, y: topMargin, width: self.frame.size.width - 20.0, height: self.frame.size.height - topMargin)
        mainTitleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainTitleLabel.textAlignment = .left
        mainTitleLabel.numberOfLines = 2
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        mainTitleLabel.textColor = .white
        mainTitleLabel.text = NSLocalizedString("app_name", comment: "")
        self.addSubview(mainTitleLabel)

        // simple button
        simpleButton.frame = CGRect(x: self.frame.size.width - 250.0, y: topMargin, width: 50.0, height: self.frame.size.height - topMargin)
        simpleButton.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        simpleButton.addTarget(self, action: #selector(simpleAction), for: .touchUpInside)
        simpleButton.isHidden = true
        self.addSubview(simpleButton)
        
        // simple imageview
        let simpleImageView = UIImageView(frame: CGRect(x: (simpleButton.frame.size.width - 40.0) / 2.0, y: (simpleButton.frame.size.height - 40.0) / 2.0, width: 40.0, height: 40.0))
        simpleImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        simpleImageView.image = UIImage(named: "simple_graph")
        simpleImageView.contentMode = .scaleAspectFit
        simpleButton.addSubview(simpleImageView)
        
        // graph tx button
        graphTxButton.frame = CGRect(x: self.frame.size.width - 200.0, y: topMargin, width: 50.0, height: self.frame.size.height - topMargin)
        graphTxButton.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        graphTxButton.addTarget(self, action: #selector(graphTxAction), for: .touchUpInside)
        graphTxButton.isHidden = true
        self.addSubview(graphTxButton)
        
        // graph tx imageview
        let graphTxImageView = UIImageView(frame: CGRect(x: (graphTxButton.frame.size.width - 40.0) / 2.0, y: (graphTxButton.frame.size.height - 40.0) / 2.0, width: 40.0, height: 40.0))
        graphTxImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        graphTxImageView.image = UIImage(named: "graphtx")
        graphTxImageView.contentMode = .scaleAspectFit
        graphTxButton.addSubview(graphTxImageView)
        
        // graph rx button
        graphRxButton.frame = CGRect(x: self.frame.size.width - 150.0, y: topMargin, width: 50.0, height: self.frame.size.height - topMargin)
        graphRxButton.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        graphRxButton.addTarget(self, action: #selector(graphRxAction), for: .touchUpInside)
        graphRxButton.isHidden = true
        self.addSubview(graphRxButton)
        
        // graph rx imageview
        let graphRxImageView = UIImageView(frame: CGRect(x: (graphRxButton.frame.size.width - 40.0) / 2.0, y: (graphRxButton.frame.size.height - 40.0) / 2.0, width: 40.0, height: 40.0))
        graphRxImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        graphRxImageView.image = UIImage(named: "graphrx")
        graphRxImageView.contentMode = .scaleAspectFit
        graphRxButton.addSubview(graphRxImageView)
        
        // delete button
        deleteButton.frame = CGRect(x: self.frame.size.width - 100.0, y: topMargin, width: 50.0, height: self.frame.size.height - topMargin)
        deleteButton.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        deleteButton.isHidden = true
        self.addSubview(deleteButton)
        
        // delete imageview
        let deleteImageView = UIImageView(frame: CGRect(x: (deleteButton.frame.size.width - 28.0) / 2.0, y: (deleteButton.frame.size.height - 28.0) / 2.0, width: 28.0, height: 28.0))
        deleteImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        deleteImageView.image = UIImage(named: "delete")!.withRenderingMode(.alwaysTemplate)
        deleteImageView.contentMode = .scaleAspectFit
        deleteImageView.tintColor = .white
        deleteButton.addSubview(deleteImageView)
        
        // scan button
        scanButton.frame = CGRect(x: self.frame.size.width - 120.0, y: topMargin, width: 70.0, height: self.frame.size.height - topMargin)
        scanButton.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        scanButton.addTarget(self, action: #selector(scanAction), for: .touchUpInside)
        scanButton.backgroundColor = .clear
        scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.setTitle(NSLocalizedString("scan", comment: ""), for: .normal)
        self.addSubview(scanButton)
        
        // menu button
        let menuButton = UIButton(frame: CGRect(x: self.frame.size.width - 50.0, y: topMargin, width: 50.0, height: self.frame.size.height - topMargin))
        menuButton.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        menuButton.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        menuButton.backgroundColor = .clear
        menuButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        menuButton.setTitleColor(.white, for: .normal)
        menuButton.setTitle(NSLocalizedString("menu", comment: ""), for: .normal)
        self.addSubview(menuButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadHomeLayout() {
        
        setTitle(title: NSLocalizedString("app_name", comment: ""))
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        deleteButton.isHidden = true
        simpleButton.isHidden = true
        graphTxButton.isHidden = true
        graphRxButton.isHidden = true
        scanButton.isHidden = false
        
    }
    
    func loadTerminalLayout(title: String?) {
        
        if let title = title {
            setTitle(title: title)
        } else {
            setTitle(title: "")
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        if screenSize.size.width > 320.0 {
            mainTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        } else {
            mainTitleLabel.text = mainTitleLabel.text?.replacingOccurrences(of: "-", with: "-\n")
            mainTitleLabel.font = UIFont.systemFont(ofSize: 10.0)
        }

        deleteButton.isHidden = false
        simpleButton.isHidden = false
        graphTxButton.isHidden = false
        graphRxButton.isHidden = false
        scanButton.isHidden = true
        
    }
    
    func setScanButtonEnabled(enabled: Bool) {
        
        scanButton.alpha = enabled ? 1.0 : 0.5
        scanButton.isEnabled = enabled
        
    }
    
    func setTitle(title: String) {
        mainTitleLabel.text = title
    }
    
    // MARK: Actions

    @objc func deleteAction() {
        self.delegate?.delete?(navigationBar: self)
    }
    
    @objc func simpleAction() {
        self.delegate?.simple?(navigationBar: self)
    }
    
    @objc func graphTxAction() {
        self.delegate?.graphTx?(navigationBar: self)
    }
    
    @objc func graphRxAction() {
        self.delegate?.graphRx?(navigationBar: self)
    }
    
    @objc func scanAction() {
        self.delegate?.scan?(navigationBar: self)
    }

    @objc func menuAction() {
        self.delegate?.menu?(navigationBar: self)
    }
    
}
