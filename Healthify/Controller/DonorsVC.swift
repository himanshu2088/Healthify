//
//  DonorsVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 25/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class DonorsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameArray = [String]()
    var locationArray = [Int]()
    var bloodArray = [String]()
    var ageArray = [String]()
    var documentIdArray = [String]()
    
    var currentName = "default"
    var currentAge = "default"
    var currentDocumentId = "default"
    var currentBlood = "default"
    var currentLocation: CLLocation?
    
    let refreshBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "refresh.png"), for: .normal)
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
        label.text = "Blood Bank"
        label.font = UIFont(name: "Avenir-Medium", size: 22.0)
        label.textColor = .black
        return label
    }()
    
    let donorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Donors available"
        label.font = UIFont(name: "Avenir-Heavy", size: 24.0)
        label.textColor = .black
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "DonorCell", bundle: nil), forCellReuseIdentifier: "donorCell")
        tableView.allowsSelection = true
        tableView.rowHeight = 100
        return tableView
    }()
    
    @objc func refresh(_ sender: UIButton) {
        nameArray.removeAll()
        bloodArray.removeAll()
        ageArray.removeAll()
        locationArray.removeAll()
        documentIdArray.removeAll()
        tableView.reloadData()
        viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        spinner.startAnimating()
        
        
        Firestore.firestore().collection("Donors").document(Auth.auth().currentUser!.uid).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.currentName = (snap?.data()!["name"] as? String)!
            self.currentAge = (snap?.data()!["age"] as? String)!
            self.currentBlood = (snap?.data()!["blood"] as? String)!
            self.currentDocumentId = snap?.documentID as! String
            let location = snap!.data()!["currentLocation"] as? String
            let locationn = location!
            let locationnn = locationn.components(separatedBy: CharacterSet(charactersIn: "<,>")).flatMap({
                Double($0)
            })
            self.currentLocation = CLLocation(latitude: locationnn[0], longitude: locationnn[1])
            
            Firestore.firestore().collection("Donors").getDocuments { (snapshot, error) in
                for document in (snapshot?.documents)! {
                    let documentId = document.documentID
                    let name = document.data()["name"] as? String
                    let blood = document.data()["blood"] as? String
                    let age = document.data()["age"] as? String
                    let location = document.data()["currentLocation"] as? String
                    let locationn = location!
                    let locationnn = locationn.components(separatedBy: CharacterSet(charactersIn: "<,>")).flatMap({
                        Double($0)
                    })
                    let coordinates = CLLocation(latitude: locationnn[0], longitude: locationnn[1])
                    
                    let distance = coordinates.distance(from: self.currentLocation!) / 1000

                    self.nameArray.append(name!)
                    self.bloodArray.append(blood!)
                    self.ageArray.append(age!)
                    self.locationArray.append(Int(distance))
                    self.documentIdArray.append(documentId)
                }
                
                if let index = self.nameArray.firstIndex(of: self.currentName) {
                    self.nameArray.remove(at: index)
                }
                
                if let index = self.bloodArray.firstIndex(of: self.currentBlood) {
                    self.bloodArray.remove(at: index)
                }
                
                if let index = self.ageArray.firstIndex(of: self.currentAge) {
                    self.ageArray.remove(at: index)
                }
                
                if let index = self.documentIdArray.firstIndex(of: self.currentDocumentId) {
                    self.documentIdArray.remove(at: index)
                }
                
                if let index = self.locationArray.firstIndex(of: 0) {
                    self.locationArray.remove(at: index)
                }
                
                self.spinner.stopAnimating()
                
                self.tableView.reloadData()
                
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
                
                self.view.addSubview(self.donorsLabel)
                self.donorsLabel.translatesAutoresizingMaskIntoConstraints = false
                self.donorsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70.0).isActive = true
                self.donorsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
                
                self.tableView.removeFromSuperview()
                
                self.view.addSubview(self.tableView)
                self.tableView.translatesAutoresizingMaskIntoConstraints = false
                self.tableView.isUserInteractionEnabled = true
                self.tableView.topAnchor.constraint(equalTo: self.donorsLabel.bottomAnchor, constant: 0.0).isActive = true
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
                
            }

            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "donorCell", for: indexPath) as? DonorCell {
            cell.ageLabel.text = ageArray[indexPath.row]
            cell.nameLabel.text = nameArray[indexPath.row]
            cell.bloodLabel.text = bloodArray[indexPath.row]
            cell.distanceLabel.text = "\(locationArray[indexPath.row])"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ParticularDonorVC") as? ParticularDonorVC
        nextViewController?.documentId = documentIdArray[indexPath.row]
        self.present(nextViewController!, animated:true, completion:nil)
    }

}
