//
//  ConfigurationViewController.swift
//  NetwO
//
//  Created by Alain Grange on 11/05/2021.
//

import UIKit

@objc protocol ConfigurationViewControllerDelegate {
    @objc optional func applyConfiguration(configurationViewController: ConfigurationViewController, list: [Int])
}

class ConfigurationViewController: UIViewController {

    var marginPerfect = 15, marginGood = 10, marginBad = 5, snrPerfect = -5, snrBad = -10, rssiPerfect = -107, rssiBad = -118
    let resetMarginPerfect = 15, resetMarginGood = 10, resetMarginBad = 5, resetSNRPerfect = -5, resetSNRBad = -10, resetRSSIPerfect = -107, resetRSSIBad = -118
    
    var yContent: CGFloat = 0.0
    
    let backgroundButton = UIButton()
    let contentView = UIView()
    let marginPerfectTextField = UITextField()
    let marginGoodTextField = UITextField()
    let marginBadTextField = UITextField()
    let rssiPerfectTextField = UITextField()
    let rssiBadTextField = UITextField()
    let snrPerfectTextField = UITextField()
    let snrBadTextField = UITextField()
    
    var delegate: ConfigurationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background button
        backgroundButton.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backgroundButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        backgroundButton.backgroundColor = .black
        backgroundButton.alpha = 0.0
        self.view.addSubview(backgroundButton)
        
        // content view
        contentView.frame = CGRect(x: 20.0, y: 0.0, width: self.view.frame.size.width - 40.0, height: 0.0)
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = ColorGreyMedium
        contentView.alpha = 0.0
        self.view.addSubview(contentView)
        
        var yPosition: CGFloat = 10.0
        
        // title label
        let titleLabel = UILabel(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 30.0))
        titleLabel.autoresizingMask = .flexibleWidth
        titleLabel.textAlignment = .center
        titleLabel.textColor = ColorTextGreyLight
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.text = NSLocalizedString("configuration", comment: "")
        contentView.addSubview(titleLabel)
        
        yPosition += titleLabel.frame.size.height + 10.0
        
        // margin title label
        let marginTitleLabel = UILabel(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 30.0))
        marginTitleLabel.autoresizingMask = .flexibleWidth
        marginTitleLabel.textAlignment = .center
        marginTitleLabel.textColor = ColorTextGreyLight
        marginTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        marginTitleLabel.text = NSLocalizedString("thresholdMargin", comment: "")
        contentView.addSubview(marginTitleLabel)
        
        yPosition += marginTitleLabel.frame.size.height + 5.0
        
        // margin perfect textfield
        marginPerfectTextField.frame = CGRect(x: 0.0, y: yPosition, width: contentView.frame.size.width / 3.0, height: 40.0)
        marginPerfectTextField.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        marginPerfectTextField.backgroundColor = .clear
        marginPerfectTextField.returnKeyType = .done
        marginPerfectTextField.keyboardType = .numberPad
        marginPerfectTextField.font = UIFont.systemFont(ofSize: 16.0)
        marginPerfectTextField.textAlignment = .left
        marginPerfectTextField.textColor = .white
        contentView.addSubview(marginPerfectTextField)
        
        let marginPerfectBottomLine = CALayer()
        marginPerfectBottomLine.frame = CGRect(x: 15.0, y: marginPerfectTextField.frame.height - 1, width: marginPerfectTextField.frame.size.width - 15.0, height: 1.0)
        marginPerfectBottomLine.backgroundColor = UIColor.white.cgColor
        marginPerfectBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        marginPerfectTextField.borderStyle = .none
        marginPerfectTextField.layer.addSublayer(marginPerfectBottomLine)
        
        let marginPerfectTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var marginPerfectBarItems = [UIBarButtonItem]()
        marginPerfectBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        marginPerfectBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        marginPerfectTextFieldToolbar.items = marginPerfectBarItems
        marginPerfectTextField.inputAccessoryView = marginPerfectTextFieldToolbar
        
        marginPerfectTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: marginPerfectTextField.frame.height))
        marginPerfectTextField.leftViewMode = .always
        
        // margin good textfield
        marginGoodTextField.frame = CGRect(x: contentView.frame.size.width / 3.0, y: yPosition, width: contentView.frame.size.width / 3.0, height: 40.0)
        marginGoodTextField.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        marginGoodTextField.backgroundColor = .clear
        marginGoodTextField.returnKeyType = .done
        marginGoodTextField.keyboardType = .numberPad
        marginGoodTextField.font = UIFont.systemFont(ofSize: 16.0)
        marginGoodTextField.textAlignment = .left
        marginGoodTextField.textColor = .white
        contentView.addSubview(marginGoodTextField)
        
        let marginGoodBottomLine = CALayer()
        marginGoodBottomLine.frame = CGRect(x: 15.0, y: marginGoodTextField.frame.height - 1, width: marginGoodTextField.frame.size.width - 15.0, height: 1.0)
        marginGoodBottomLine.backgroundColor = UIColor.white.cgColor
        marginGoodBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        marginGoodTextField.borderStyle = .none
        marginGoodTextField.layer.addSublayer(marginGoodBottomLine)
        
        let marginGoodTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var marginGoodBarItems = [UIBarButtonItem]()
        marginGoodBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        marginGoodBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        marginGoodTextFieldToolbar.items = marginGoodBarItems
        marginGoodTextField.inputAccessoryView = marginGoodTextFieldToolbar
        
        marginGoodTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: marginGoodTextField.frame.height))
        marginGoodTextField.leftViewMode = .always
        
        // margin bad textfield
        marginBadTextField.frame = CGRect(x: (contentView.frame.size.width / 3.0) * 2.0, y: yPosition, width: contentView.frame.size.width / 3.0, height: 40.0)
        marginBadTextField.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        marginBadTextField.backgroundColor = .clear
        marginBadTextField.returnKeyType = .done
        marginBadTextField.keyboardType = .numberPad
        marginBadTextField.font = UIFont.systemFont(ofSize: 16.0)
        marginBadTextField.textAlignment = .left
        marginBadTextField.textColor = .white
        contentView.addSubview(marginBadTextField)
        
        let marginBadBottomLine = CALayer()
        marginBadBottomLine.frame = CGRect(x: 15.0, y: marginBadTextField.frame.height - 1, width: marginBadTextField.frame.size.width - 30.0, height: 1.0)
        marginBadBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        marginBadTextField.borderStyle = .none
        marginBadTextField.layer.addSublayer(marginBadBottomLine)
        
        let marginBadTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var marginBadBarItems = [UIBarButtonItem]()
        marginBadBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        marginBadBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        marginBadTextFieldToolbar.items = marginBadBarItems
        marginBadTextField.inputAccessoryView = marginBadTextFieldToolbar
        
        marginBadTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: marginBadTextField.frame.height))
        marginBadTextField.leftViewMode = .always
        
        yPosition += marginPerfectTextField.frame.size.height + 10.0
        
        // rssi title label
        let rssiTitleLabel = UILabel(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 30.0))
        rssiTitleLabel.autoresizingMask = .flexibleWidth
        rssiTitleLabel.textAlignment = .center
        rssiTitleLabel.textColor = ColorTextGreyLight
        rssiTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        rssiTitleLabel.text = NSLocalizedString("thresholdRSSI", comment: "")
        contentView.addSubview(rssiTitleLabel)
        
        yPosition += rssiTitleLabel.frame.size.height + 5.0
        
        // rssi perfect textfield
        rssiPerfectTextField.frame = CGRect(x: 0.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0)
        rssiPerfectTextField.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        rssiPerfectTextField.backgroundColor = .clear
        rssiPerfectTextField.returnKeyType = .done
        rssiPerfectTextField.keyboardType = .numberPad
        rssiPerfectTextField.font = UIFont.systemFont(ofSize: 16.0)
        rssiPerfectTextField.textAlignment = .left
        rssiPerfectTextField.textColor = .white
        contentView.addSubview(rssiPerfectTextField)
        
        let rssiPerfectBottomLine = CALayer()
        rssiPerfectBottomLine.frame = CGRect(x: 15.0, y: rssiPerfectTextField.frame.height - 1, width: rssiPerfectTextField.frame.size.width - 15.0, height: 1.0)
        rssiPerfectBottomLine.backgroundColor = UIColor.white.cgColor
        rssiPerfectBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        rssiPerfectTextField.borderStyle = .none
        rssiPerfectTextField.layer.addSublayer(rssiPerfectBottomLine)
        
        let rssiPerfectTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var rssiPerfectBarItems = [UIBarButtonItem]()
        rssiPerfectBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        rssiPerfectBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        rssiPerfectTextFieldToolbar.items = rssiPerfectBarItems
        rssiPerfectTextField.inputAccessoryView = rssiPerfectTextFieldToolbar
        
        rssiPerfectTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: rssiPerfectTextField.frame.height))
        rssiPerfectTextField.leftViewMode = .always
        
        // rssi bad textfield
        rssiBadTextField.frame = CGRect(x: contentView.frame.size.width / 2.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0)
        rssiBadTextField.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        rssiBadTextField.backgroundColor = .clear
        rssiBadTextField.returnKeyType = .done
        rssiBadTextField.keyboardType = .numberPad
        rssiBadTextField.font = UIFont.systemFont(ofSize: 16.0)
        rssiBadTextField.textAlignment = .left
        rssiBadTextField.textColor = .white
        contentView.addSubview(rssiBadTextField)
        
        let rssiBadBottomLine = CALayer()
        rssiBadBottomLine.frame = CGRect(x: 15.0, y: rssiBadTextField.frame.height - 1, width: rssiBadTextField.frame.size.width - 30.0, height: 1.0)
        rssiBadBottomLine.backgroundColor = UIColor.white.cgColor
        rssiBadBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        rssiBadTextField.borderStyle = .none
        rssiBadTextField.layer.addSublayer(rssiBadBottomLine)
        
        let rssiBadTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var rssiBadBarItems = [UIBarButtonItem]()
        rssiBadBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        rssiBadBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        rssiBadTextFieldToolbar.items = rssiBadBarItems
        rssiBadTextField.inputAccessoryView = rssiBadTextFieldToolbar
        
        rssiBadTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: rssiBadTextField.frame.height))
        rssiBadTextField.leftViewMode = .always
        
        yPosition += rssiPerfectTextField.frame.size.height + 10.0
        
        // snr title label
        let snrTitleLabel = UILabel(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 30.0))
        snrTitleLabel.autoresizingMask = .flexibleWidth
        snrTitleLabel.textAlignment = .center
        snrTitleLabel.textColor = ColorTextGreyLight
        snrTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        snrTitleLabel.text = NSLocalizedString("thresholdSNR", comment: "")
        contentView.addSubview(snrTitleLabel)
        
        yPosition += snrTitleLabel.frame.size.height + 5.0
        
        // snr perfect textfield
        snrPerfectTextField.frame = CGRect(x: 0.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0)
        snrPerfectTextField.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        snrPerfectTextField.backgroundColor = .clear
        snrPerfectTextField.returnKeyType = .done
        snrPerfectTextField.keyboardType = .numberPad
        snrPerfectTextField.font = UIFont.systemFont(ofSize: 16.0)
        snrPerfectTextField.textAlignment = .left
        snrPerfectTextField.textColor = .white
        contentView.addSubview(snrPerfectTextField)
        
        let snrPerfectBottomLine = CALayer()
        snrPerfectBottomLine.frame = CGRect(x: 15.0, y: snrPerfectTextField.frame.height - 1, width: snrPerfectTextField.frame.size.width - 15.0, height: 1.0)
        snrPerfectBottomLine.backgroundColor = UIColor.white.cgColor
        snrPerfectBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        snrPerfectTextField.borderStyle = .none
        snrPerfectTextField.layer.addSublayer(snrPerfectBottomLine)
        
        let snrPerfectTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var snrPerfectBarItems = [UIBarButtonItem]()
        snrPerfectBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        snrPerfectBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        snrPerfectTextFieldToolbar.items = snrPerfectBarItems
        snrPerfectTextField.inputAccessoryView = snrPerfectTextFieldToolbar
        
        snrPerfectTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: snrPerfectTextField.frame.height))
        snrPerfectTextField.leftViewMode = .always
        
        // snr bad textfield
        snrBadTextField.frame = CGRect(x: contentView.frame.size.width / 2.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0)
        snrBadTextField.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        snrBadTextField.backgroundColor = .clear
        snrBadTextField.returnKeyType = .done
        snrBadTextField.keyboardType = .numberPad
        snrBadTextField.font = UIFont.systemFont(ofSize: 16.0)
        snrBadTextField.textAlignment = .left
        snrBadTextField.textColor = .white
        contentView.addSubview(snrBadTextField)
        
        let snrBadBottomLine = CALayer()
        snrBadBottomLine.frame = CGRect(x: 15.0, y: snrBadTextField.frame.height - 1, width: snrBadTextField.frame.size.width - 30.0, height: 1.0)
        snrBadBottomLine.backgroundColor = UIColor.white.cgColor
        snrBadBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        snrBadTextField.borderStyle = .none
        snrBadTextField.layer.addSublayer(snrBadBottomLine)
        
        let snrBadTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var snrBadBarItems = [UIBarButtonItem]()
        snrBadBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        snrBadBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        snrBadTextFieldToolbar.items = snrBadBarItems
        snrBadTextField.inputAccessoryView = snrBadTextFieldToolbar
        
        snrBadTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: snrBadTextField.frame.height))
        snrBadTextField.leftViewMode = .always
        
        yPosition += snrPerfectTextField.frame.size.height + 10.0
        
        // color indicator view
        let colorIndicatorView = UIView(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 5.0))
        colorIndicatorView.autoresizingMask = .flexibleWidth
        contentView.addSubview(colorIndicatorView)
        
        let colorIndicatorGradientLayer = CAGradientLayer()
        colorIndicatorGradientLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        colorIndicatorGradientLayer.locations = [0.0, 1.0]
        colorIndicatorGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        colorIndicatorGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        colorIndicatorGradientLayer.frame = colorIndicatorView.bounds
                
        colorIndicatorView.layer.insertSublayer(colorIndicatorGradientLayer, at:0)
        
        yPosition += colorIndicatorView.frame.size.height + 10.0
        
        // apply button
        let applyButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
        applyButton.autoresizingMask = .flexibleWidth
        applyButton.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
        applyButton.backgroundColor = ColorGreyLight
        applyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
        contentView.addSubview(applyButton)
        
        yPosition += applyButton.frame.size.height + 10.0
        
        // reset button
        let resetButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
        resetButton.autoresizingMask = .flexibleWidth
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        resetButton.backgroundColor = ColorGreyLight
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.setTitle(NSLocalizedString("reset", comment: ""), for: .normal)
        contentView.addSubview(resetButton)
        
        yPosition += resetButton.frame.size.height + 20.0
        
        // content view size
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: ((self.view.frame.size.height - yPosition) / 2.0), width: self.view.frame.size.width - 40.0, height: yPosition)
        contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        
        self.yContent = contentView.frame.origin.y
        
        // load datas
        reloadDatas()
        
        // keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.5
            self.contentView.alpha = 1.0

        }, completion: { (finished: Bool) in

        })
        
    }
    
    func reloadDatas() {
                
        marginPerfectTextField.text = "\(marginPerfect)"
        marginGoodTextField.text = "\(marginGood)"
        marginBadTextField.text = "\(marginBad)"
        rssiPerfectTextField.text = "\(rssiPerfect)"
        rssiBadTextField.text = "\(rssiBad)"
        snrPerfectTextField.text = "\(snrPerfect)"
        snrBadTextField.text = "\(snrBad)"
        
    }
    
    // MARK: - Actions
    
    @objc func dismissAction() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.0
            self.contentView.alpha = 0.0

        }, completion: { (finished: Bool) in
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    
    @objc func doneAction() {
        
        marginPerfectTextField.resignFirstResponder()
        marginGoodTextField.resignFirstResponder()
        marginBadTextField.resignFirstResponder()
        rssiPerfectTextField.resignFirstResponder()
        rssiBadTextField.resignFirstResponder()
        snrPerfectTextField.resignFirstResponder()
        snrBadTextField.resignFirstResponder()
        
    }
    
    @objc func applyAction() {
        
        // hide keyboard
        doneAction()
        
        if let value = Int(marginPerfectTextField.text ?? String(marginPerfect)) { marginPerfect = value }
        if let value = Int(marginGoodTextField.text ?? String(marginGood)) { marginGood = value }
        if let value = Int(marginBadTextField.text ?? String(marginBad)) { marginBad = value }
        if let value = Int(rssiPerfectTextField.text ?? String(rssiPerfect)) { rssiPerfect = value }
        if let value = Int(rssiBadTextField.text ?? String(rssiBad)) { rssiBad = value }
        if let value = Int(snrPerfectTextField.text ?? String(snrPerfect)) { snrPerfect = value }
        if let value = Int(snrBadTextField.text ?? String(snrBad)) { snrBad = value }

        if marginPerfect > marginGood && marginGood > marginBad && rssiPerfect > rssiBad && snrPerfect > snrBad {
            
            var list = [Int]()
            list.append(marginPerfect)
            list.append(marginGood)
            list.append(marginBad)
            list.append(rssiPerfect)
            list.append(rssiBad)
            list.append(snrPerfect)
            list.append(snrBad)
            
            self.delegate?.applyConfiguration?(configurationViewController: self, list: list)
            
            dismissAction()
            
        } else {
            Utils.showAlert(view: self.view, message: NSLocalizedString("errorThrehsold", comment: ""))
        }

    }
    
    @objc func resetAction() {
        
        marginPerfectTextField.text = "\(resetMarginPerfect)"
        marginGoodTextField.text = "\(resetMarginGood)"
        marginBadTextField.text = "\(resetMarginBad)"
        rssiPerfectTextField.text = "\(resetRSSIPerfect)"
        rssiBadTextField.text = "\(resetRSSIBad)"
        snrPerfectTextField.text = "\(resetSNRPerfect)"
        snrBadTextField.text = "\(resetSNRBad)"
        
    }
    
    // MARK: - Keyboard Management
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let animationDuration: TimeInterval = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue)), .beginFromCurrentState], animations: {
            
            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.yContent - 50.0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            
        }, completion: { (finished: Bool) in })
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let animationDuration: TimeInterval = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue)), .beginFromCurrentState], animations: {
            
            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.yContent, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            
        }, completion: { (finished: Bool) in })
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
}
