//
//  ImagesVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 10/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit

class ImagesVC: UIViewController {
    
    var imagesArray = [UIImage]()
    var currentImageIndex = 0
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<- back", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    @objc func back(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.font = UIFont(name: "Avenir-Medium", size: 22.0)
        label.textColor = .black
        return label
    }()
    
    let photosView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<-", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("->", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isUserInteractionEnabled = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.lineView)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(self.profileLabel)
        self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
        self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        self.view.addSubview(photosView)
        photosView.translatesAutoresizingMaskIntoConstraints = false
        photosView.isUserInteractionEnabled = true
        photosView.contentMode = .scaleAspectFill
        photosView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        photosView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        photosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0).isActive = true
        photosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        photosView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        photosView.image = imagesArray[currentImageIndex]
        
        self.view.addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.isUserInteractionEnabled = true
        leftButton.topAnchor.constraint(equalTo: self.photosView.bottomAnchor, constant: 20.0).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        leftButton.addTarget(self, action: #selector(left(_:)), for: .touchUpInside)
        
        self.view.addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.isUserInteractionEnabled = true
        rightButton.topAnchor.constraint(equalTo: self.photosView.bottomAnchor, constant: 20.0).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        rightButton.addTarget(self, action: #selector(right(_:)), for: .touchUpInside)
    
    }
    
    @objc func left(_ sender: UIButton) {
        if (currentImageIndex > 0) && (currentImageIndex <= imagesArray.count) {
            currentImageIndex = currentImageIndex - 1
            photosView.image = imagesArray[currentImageIndex]
        }
    }
    
    @objc func right(_ sender: UIButton) {
        if (currentImageIndex >= 0) && (currentImageIndex < imagesArray.count) {
            currentImageIndex = currentImageIndex + 1
            if currentImageIndex != imagesArray.count {
                photosView.image = imagesArray[currentImageIndex]
            }
        }
    }
    
}
