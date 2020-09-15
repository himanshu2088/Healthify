//
//  AdsVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 12/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AdsVC: UIViewController {
    
    var itemNameArray = [String]()
    var itemDescArray = [String]()
    var itemQuantityArray = [String]()
    var itemPriceArray = [String]()
    var itemImagesArray = [[String]]()
    var documentIdArray = [String]()
    var photosArray = [UIImage]()
 
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
        label.text = "Your Ads"
        label.font = UIFont(name: "Avenir-Medium", size: 22.0)
        label.textColor = .black
        return label
    }()
    
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
    
    func refresh() {
        itemNameArray.removeAll()
        itemDescArray.removeAll()
        itemQuantityArray.removeAll()
        itemPriceArray.removeAll()
        itemPriceArray.removeAll()
        documentIdArray.removeAll()
        tableView.reloadData()
        viewDidLoad()
    }
    
    @objc func refresh(_ sender: UIButton) {
        itemNameArray.removeAll()
        itemDescArray.removeAll()
        itemQuantityArray.removeAll()
        itemPriceArray.removeAll()
        itemPriceArray.removeAll()
        documentIdArray.removeAll()
        tableView.reloadData()
        viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        activityIndicator.startAnimating()
        
        Firestore.firestore().collection("Items").whereField("userEmail", isEqualTo: (Auth.auth().currentUser?.email)!).getDocuments { (snapshot, error) in
            let documents = (snapshot?.documents)!
            for document in documents {
                    let documentId = document.documentID
                    let itemDesc = document.data()["itemDesc"] as? String
                    let itemName = document.data()["itemName"] as? String
                    let itemPrice = document.data()["itemPrice"] as? String
                    let itemQuantity = document.data()["itemQuantity"] as? String
                    let itemImages = document.data()["photoUrl"] as? [String]

                    self.documentIdArray.append(documentId)
                    self.itemDescArray.append(itemDesc!)
                    self.itemNameArray.append(itemName!)
                    self.itemPriceArray.append(itemPrice!)
                    self.itemQuantityArray.append(itemQuantity!)
                    self.itemImagesArray.append(itemImages!)
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
        self.refreshBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        self.refreshBtn.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.refreshBtn.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.refreshBtn.centerYAnchor.constraint(equalTo: self.profileLabel.centerYAnchor, constant: 0.0).isActive = true
        self.refreshBtn.addTarget(self, action: #selector(self.refresh(_:)), for: .touchUpInside)

    }
    
}

extension AdsVC: UITableViewDataSource, UITableViewDelegate {
    
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
        
        func deleteAd() {
            Firestore.firestore().collection("Items").document(documentIdArray[indexPath.row]).delete { (error) in
                if let error = error {
                    print("error while deleting, \(error.localizedDescription)")
                } else {
                    let alert = UIAlertController(title: "Success", message: "Ad deleted successfully.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.refresh()
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        let alert = UIAlertController(title: "Choose one..", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "See Photos", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            seePhotos()
        })
        let action2 = UIAlertAction(title: "Delete Ad", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            deleteAd()
        })
        let action3 = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
}
