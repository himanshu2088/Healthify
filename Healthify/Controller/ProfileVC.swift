//
//  ProfileVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 12/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileVC: UIViewController {
    
    let profileTitles = ["Account", "Your ads", "Edit profile", "Help", "Logout"]

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .black
        return activity
    }()

    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.font = UIFont(name: "Avenir-Medium", size: 18.0)
        label.textColor = .black
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 20.0)
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        tableView.allowsSelection = true
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        self.view.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.view.addSubview(self.lineView)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(self.profileLabel)
        self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
        self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        activityIndicator.startAnimating()
        
        Firestore.firestore().collection("Donors").document((Auth.auth().currentUser?.uid)!).getDocument { (snapshot, error) in
            if let error = error {
                print("Error while getting name, \(error.localizedDescription)")
            } else {
                let name = snapshot?.data()!["name"] as? String
                
                self.activityIndicator.stopAnimating()
                
                self.view.addSubview(self.imageView)
                self.imageView.translatesAutoresizingMaskIntoConstraints = false
                self.imageView.isUserInteractionEnabled = false
                self.imageView.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 10.0).isActive = true
                self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
                self.imageView.image = UIImage(named: "profile.png")

                self.view.addSubview(self.nameLabel)
                self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
                self.nameLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 15.0).isActive = true
                self.nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
                self.nameLabel.text = name
                
                self.view.addSubview(self.lineView2)
                self.lineView2.translatesAutoresizingMaskIntoConstraints = false
                self.lineView2.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10.0).isActive = true
                self.lineView2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.lineView2.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10).isActive = true
                self.lineView2.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
                
                self.view.addSubview(self.tableView)
                self.tableView.translatesAutoresizingMaskIntoConstraints = false
                self.tableView.topAnchor.constraint(equalTo: self.lineView2.bottomAnchor, constant: 0.0).isActive = true
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
                
            }
            

        }
        
    }

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("sdas")
        return profileTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileCell {
            cell.label.text = profileTitles[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as? MyProfileVC
            present(viewController!, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AdsVC") as? AdsVC
            present(viewController!, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "UpdateDataVC") as? UpdateDataVC
            present(viewController!, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            print("Help")
        } else if indexPath.row == 4 {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                }, completion: nil)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
}
