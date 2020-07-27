//
//  MyProfileVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 26/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase

class MyProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "left-arrow.png"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    @objc func back(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "MY PROFILE"
        label.font = UIFont(name: "Avenir-Medium", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    let updateBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UPDATE DATA", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.tintColor = .black
        return button
    }()
    
    
    let keyArray = ["Name", "Age", "Address", "Blood", "Mobile", "Email"]
    
    var valueArray = [String]()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "ParticularDonorCell", bundle: nil), forCellReuseIdentifier: "particularDonorCell")
        tableView.allowsSelection = false
        tableView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9882352941, blue: 0.8549019608, alpha: 1)
        tableView.rowHeight = 130
        return tableView
    }()
    
    @objc func updateData(_ sender : UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateDataVC") as? UpdateDataVC
        self.present(nextViewController!, animated:true, completion:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white
        
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isUserInteractionEnabled = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.addTarget(self, action: #selector(back(_:)), for: .allEvents)
        
        self.view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 22.0).isActive = true
        profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        spinner.startAnimating()
        
        Firestore.firestore().collection("Donors").document((Auth.auth().currentUser?.uid)!).getDocument { (snap, error) in
            if let error = error {
                print("Error getting self documents,\(error.localizedDescription)")
            }
            let data = snap?.data()
            let name = data!["name"] as? String
            let age = data!["age"] as? String
            let address = data!["address"] as? String
            let blood = data!["blood"] as? String
            let mobile = data!["mobile"] as? String
            let email = data!["email"] as? String
            
            self.valueArray.insert(name!, at: 0)
            self.valueArray.insert(age!, at: 1)
            self.valueArray.insert(address!, at: 2)
            self.valueArray.insert(blood!, at: 3)
            self.valueArray.insert(mobile!, at: 4)
            self.valueArray.insert(email!, at: 5)
            
            self.spinner.stopAnimating()
            
            self.view.addSubview(self.updateBtn)
            self.updateBtn.translatesAutoresizingMaskIntoConstraints = false
            self.updateBtn.isUserInteractionEnabled = true
            self.updateBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
            self.updateBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            self.updateBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            self.updateBtn.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 20.0).isActive = true
            self.updateBtn.addTarget(self, action: #selector(self.updateData(_:)), for: .touchUpInside)
            
            self.view.addSubview(self.tableView)
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.isUserInteractionEnabled = true
            self.tableView.topAnchor.constraint(equalTo: self.updateBtn.bottomAnchor, constant: 10.0).isActive = true
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "particularDonorCell", for: indexPath) as? ParticularDonorCell {
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = valueArray[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
