//
//  DebugView.swift
//  NetwO
//
//  Created by Alain Grange on 10/05/2021.
//

import UIKit

@objc protocol DebugViewDelegate {
    @objc optional func sendFromDebugView(debugView: DebugView, value: String)
}

class DebugView: UIView, UITextFieldDelegate {
    
    let debugLabel = UITextView()
    let separatorView = UIView()
    let debugTextField = UITextField()
    let sendButton = UIButton()
    
    var delegate: DebugViewDelegate?
    
    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // background
        self.backgroundColor = ColorGrey
        
        // debug label
        debugLabel.frame = CGRect(x: 10.0, y: 0.0, width: self.frame.size.width - 20.0, height: self.frame.size.height - 44.0)
        debugLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        debugLabel.backgroundColor = .clear
        debugLabel.isEditable = false
        debugLabel.showsVerticalScrollIndicator = false
        debugLabel.showsHorizontalScrollIndicator = false
        debugLabel.font = UIFont.systemFont(ofSize: 14.0)
        debugLabel.textAlignment = .left
        debugLabel.textColor = .white
        self.addSubview(debugLabel)
        
        // separator view
        separatorView.frame = CGRect(x: 0.0, y: self.frame.size.height - 44.0, width: self.frame.size.width, height: 1.0)
        separatorView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        separatorView.backgroundColor = ColorTextGreyLight50
        self.addSubview(separatorView)
        
        // debug textfield
        debugTextField.frame = CGRect(x: 20.0, y: self.frame.size.height - 44.0, width: self.frame.size.width - 20.0, height: 44.0)
        debugTextField.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        debugTextField.delegate = self
        debugTextField.autocorrectionType = .no
        debugTextField.autocapitalizationType = .none
        debugTextField.backgroundColor = .clear
        debugTextField.returnKeyType = .done
        debugTextField.keyboardType = .default
        debugTextField.font = UIFont.systemFont(ofSize: 16.0)
        debugTextField.textAlignment = .left
        debugTextField.textColor = .white
        self.addSubview(debugTextField)
        
        // send button
        sendButton.frame = CGRect(x: self.frame.size.width - 44.0, y: self.frame.size.height - 44.0, width: 44.0, height: 44.0)
        sendButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        self.addSubview(sendButton)
        
        // send imageview
        let sendImageView = UIImageView(frame: CGRect(x: (sendButton.frame.size.width - 30.0) / 2.0, y: (sendButton.frame.size.height - 30.0) / 2.0, width: 30.0, height: 30.0))
        sendImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        sendImageView.image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendImageView.tintColor = .white
        sendImageView.contentMode = .scaleAspectFit
        sendButton.addSubview(sendImageView)
        
        // keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setValue(attributedString: NSAttributedString) {
        debugLabel.attributedText = attributedString
    }
    
    func appendValue(attributedString: NSAttributedString) {
        
        let currentAttributedString = debugLabel.attributedText.mutableCopy() as! NSMutableAttributedString
        currentAttributedString.append(attributedString)
        debugLabel.attributedText = currentAttributedString
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.debugLabel.setContentOffset(CGPoint(x: 0, y: self.debugLabel.contentSize.height - self.debugLabel.frame.size.height), animated:false)
        }
        
    }
    
    // MARK: - Actions
    
    @objc func sendAction() {
        
        if let value = debugTextField.text, value.count > 0 {
            delegate?.sendFromDebugView?(debugView: self, value: value)
        }
        
        // hide keyboard and clear text
        debugTextField.resignFirstResponder()
        debugTextField.text = ""
        
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debugTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - Keyboard Management
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let animationDuration: TimeInterval = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        let keyboardEndFrame: CGRect = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        let intersection = self.convert(keyboardEndFrame, from: nil).intersection(self.bounds)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue)), .beginFromCurrentState], animations: {
            
            self.debugLabel.frame = CGRect(x: 10.0, y: 0.0, width: self.frame.size.width - 20.0, height: self.frame.size.height - intersection.height - 44.0)
            self.separatorView.frame = CGRect(x: 0.0, y: self.frame.size.height - intersection.height - 44.0, width: self.frame.size.width, height: 1.0)
            self.debugTextField.frame = CGRect(x: 20.0, y: self.frame.size.height - intersection.height - 44.0, width: self.frame.size.width - 20.0, height: 44.0)
            self.sendButton.frame = CGRect(x: self.frame.size.width - 44.0, y: self.frame.size.height - intersection.height - 44.0, width: 44.0, height: 44.0)
            
        }, completion: { (finished: Bool) in })
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let animationDuration: TimeInterval = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue)), .beginFromCurrentState], animations: {
            
            self.debugLabel.frame = CGRect(x: 10.0, y: 0.0, width: self.frame.size.width - 20.0, height: self.frame.size.height - 44.0)
            self.separatorView.frame = CGRect(x: 0.0, y: self.frame.size.height - 44.0, width: self.frame.size.width, height: 1.0)
            self.debugTextField.frame = CGRect(x: 20.0, y: self.frame.size.height - 44.0, width: self.frame.size.width - 20.0, height: 44.0)
            self.sendButton.frame = CGRect(x: self.frame.size.width - 44.0, y: self.frame.size.height - 44.0, width: 44.0, height: 44.0)
            
        }, completion: { (finished: Bool) in })
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
}
