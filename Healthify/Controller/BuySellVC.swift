//
//  BuySellVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 06/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class BuySellVC: UIViewController {
    
    var itemNameArray = [String]()
    var itemDescArray = [String]()
    var itemQuantityArray = [String]()
    var itemPriceArray = [String]()
    var itemImagesArray = [[String]]()
    var documentIdArray = [String]()
    var itemEmailArray = [String]()
    var photosArray = [UIImage]()
    
    let addBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add.png"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .black
        return activity
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
    
    @objc func addItem(_: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AddItemVC") as? AddItemVC
        present(viewController!, animated: true, completion: nil)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "ItemsCell", bundle: nil), forCellReuseIdentifier: "itemsCell")
        tableView.allowsSelection = true
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let refreshBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "refresh.png"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    @objc func refresh(_ sender: UIButton) {
        itemNameArray.removeAll()
        itemDescArray.removeAll()
        itemQuantityArray.removeAll()
        itemPriceArray.removeAll()
        itemPriceArray.removeAll()
        documentIdArray.removeAll()
        itemEmailArray.removeAll()
        tableView.reloadData()
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        activityIndicator.startAnimating()
        Firestore.firestore().collection("Items").getDocuments { (snapshot, error) in
            let documents = (snapshot?.documents)!
            for document in documents {
                if (document.data()["userEmail"] as? String) == (Auth.auth().currentUser?.email)! {
                    continue
                } else {
                    let documentId = document.documentID
                    let itemDesc = document.data()["itemDesc"] as? String
                    let itemName = document.data()["itemName"] as? String
                    let itemPrice = document.data()["itemPrice"] as? String
                    let itemQuantity = document.data()["itemQuantity"] as? String
                    let itemImages = document.data()["photoUrl"] as? [String]
                    let itemEmail = document.data()["userEmail"] as? String

                    self.documentIdArray.append(documentId)
                    self.itemDescArray.append(itemDesc!)
                    self.itemNameArray.append(itemName!)
                    self.itemPriceArray.append(itemPrice!)
                    self.itemQuantityArray.append(itemQuantity!)
                    self.itemImagesArray.append(itemImages!)
                    self.itemEmailArray.append(itemEmail!)

                }
            }
            
            self.activityIndicator.stopAnimating()
            
            self.tableView.reloadData()
                        
            self.view.addSubview(self.tableView)
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 61.0).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        }
        
        self.view.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
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
        
        self.view.addSubview(self.refreshBtn)
        self.refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        self.refreshBtn.isUserInteractionEnabled = true
        self.refreshBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        self.refreshBtn.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.refreshBtn.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.refreshBtn.centerYAnchor.constraint(equalTo: self.profileLabel.centerYAnchor, constant: 0.0).isActive = true
        self.refreshBtn.addTarget(self, action: #selector(self.refresh(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.addBtn)
        self.addBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addBtn.isUserInteractionEnabled = true
        self.addBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        self.addBtn.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.addBtn.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.addBtn.centerYAnchor.constraint(equalTo: self.profileLabel.centerYAnchor, constant: 0.0).isActive = true
        self.addBtn.addTarget(self, action: #selector(self.addItem(_:)), for: .touchUpInside)
        
        
    }
    
}

extension BuySellVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath) as? ItemsCell {
            cell.itemName.text = itemNameArray[indexPath.row]
            cell.itemDesc.text = itemDescArray[indexPath.row]
            cell.itemPrice.text = itemNameArray[indexPath.row]
            cell.itemQuantity.text = "\(itemQuantityArray[indexPath.row])"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        func seePhotos() {
            photosArray.removeAll()
            activityIndicator.startAnimating()
            let photoUrls = itemImagesArray[indexPath.row]
            for photoUrl in photoUrls {
                let url = URL(string: photoUrl)
                let data = try? Data(contentsOf: url!)
                self.photosArray.append(UIImage(data: data!)!)
            }
            activityIndicator.stopAnimating()
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "ImagesVC") as? ImagesVC
            viewController?.imagesArray = photosArray
            present(viewController!, animated: true, completion: nil)
    }
        
        func callPerson() {
            activityIndicator.startAnimating()
            let userEmail = itemEmailArray[indexPath.row]
            Firestore.firestore().collection("Donors").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error while getting contact of the user, \(error.localizedDescription)")
                } else {
                    let mobile = snapshot?.documents[0].data()["mobile"] as? String
                    let url: NSURL = URL(string: "TEL://\(mobile!)")! as NSURL
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
        }
        
        func chatVC() {
            
        }
        
        let alert = UIAlertController(title: "Choose one..", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "See Photos", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            seePhotos()
        })
        let action2 = UIAlertAction(title: "Call Person", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            callPerson()
        })
        let action3 = UIAlertAction(title: "Chat with person", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            chatVC()
        })
        let action4 = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        present(alert, animated: true, completion: nil)
    }
    
}
