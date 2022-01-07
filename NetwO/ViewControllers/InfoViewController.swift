//
//  InfoViewController.swift
//  NetwO
//
//  Created by Alain Grange on 26/05/2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    let backgroundButton = UIButton()
    let contentView = UIView()
    let infoLabel = UILabel()
    
    var image: UIImage?

    required init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        
        self.image = image
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
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
        
        var yPosition: CGFloat = 20.0
        
        if let image = self.image {
            
            // imageview
            let imageView = UIImageView(frame: CGRect(x: (contentView.frame.size.width - 218.0) / 2.0, y: yPosition, width: 218.0, height: 214.0))
            imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            contentView.addSubview(imageView)
            
            yPosition += imageView.frame.size.height + 20.0
            
        }
        
        // info label
        infoLabel.frame = CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 60.0)
        infoLabel.autoresizingMask = .flexibleWidth
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 16.0)
        infoLabel.textColor = ColorTextGreyLight
        infoLabel.sizeToFit()
        infoLabel.frame = CGRect(x: infoLabel.frame.origin.x, y: infoLabel.frame.origin.y, width: contentView.frame.size.width - 40.0, height: infoLabel.frame.size.height)
        contentView.addSubview(infoLabel)
        
        yPosition += infoLabel.frame.size.height + 20.0
        
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
    
    func setText(text: String) {
        infoLabel.text = text
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
    
}
