//
//  OCRVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 25/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit

class OCRVC: UIViewController {
    
    let addBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add.png"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Healthify"
        label.font = UIFont(name: "Avenir-Medium", size: 22.0)
        label.textColor = .black
        return label
    }()
    
    let documentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Press '+' button to scan documents and make a pdf of the text."
        label.numberOfLines = 3
        label.font = UIFont(name: "Avenir-Medium", size: 24.0)
        label.textColor = .black
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "DonorCell", bundle: nil), forCellReuseIdentifier: "donorCell")
        tableView.allowsSelection = true
        tableView.rowHeight = 100
        return tableView
    }()
    
    @objc func addDocument(_ sender: UIButton) {
  
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CameraVC") as? CameraVC
        self.present(nextViewController!, animated:true, completion:nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.lineView)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(self.profileLabel)
        self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
        self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        self.view.addSubview(self.addBtn)
        self.addBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addBtn.isUserInteractionEnabled = true
        self.addBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        self.addBtn.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.addBtn.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.addBtn.centerYAnchor.constraint(equalTo: self.profileLabel.centerYAnchor, constant: 0.0).isActive = true
        self.addBtn.addTarget(self, action: #selector(addDocument(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.documentsLabel)
        self.documentsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.documentsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        self.documentsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        self.documentsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        self.documentsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
    }

    
}
