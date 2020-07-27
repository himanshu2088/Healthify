//
//  UpdateDataVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 26/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import CoreLocation

class UpdateDataVC: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var location : CLLocation?
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "UPDATE DATA"
        label.font = UIFont(name: "Avenir-Medium", size: 18.0)
        label.textColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "left-arrow.png"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    @objc func back(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
    let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let nameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Name*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let ageTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Age*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let mobileTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Mobile number*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let addressTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Address*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let currentLocationTextField: UILabel = {
        let label = UILabel()
        label.text = "Current location*"
        label.textColor = .black
        return label
    }()
    
    let currentLocationBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Location", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 22.0)
        return button
    }()
    
    let bloodTypeTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Blood group*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    @objc func detectLocation(_ sender : UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    let signUpBtn: UIButton = {
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
    
    @objc func update(_ sender : UIButton) {
        
        spinner.startAnimating()

        guard let name = nameTextField.text, let age = ageTextField.text, let mobile = nameTextField.text, let address = addressTextField.text, let bloodType = bloodTypeTextField.text else { return }
        
        if name == "" || age == "" || mobile == "" || address == "" || bloodType == "" {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Please enter all the mandatory fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if currentLocationTextField.text == "" {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Location could not fetched. Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            self.saveData()
        }
    }
    
    func saveData() {
        
        guard let name = nameTextField.text, let age = ageTextField.text, let mobile = mobileTextField.text, let address = addressTextField.text, let currentLocation = currentLocationTextField.text, let bloodType = bloodTypeTextField.text else { return }
        
        Firestore.firestore().collection("Donors").document((Auth.auth().currentUser?.uid)!).updateData([
            "name" : name,
            "age" : age,
            "mobile" : mobile,
            "address" : address,
            "currentLocation" : (currentLocationTextField.text)!,
            "blood" : bloodType
        ]) { (error) in
            if let error = error {
                print("Error setting data of createUser, \(error.localizedDescription)")
            } else {
                self.spinner.stopAnimating()
                let alert = UIAlertController(title: "Success", message: "Data updated successfully.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        spinner.startAnimating()
        
        Firestore.firestore().collection("Donors").document((Auth.auth().currentUser?.uid)!).getDocument { (snap, error) in
            if let error = error {
                print("error getting data \(error.localizedDescription)")
                return
            }
            let data = snap?.data()
            self.nameTextField.text = data!["name"] as? String
            self.ageTextField.text = data!["age"] as? String
            self.mobileTextField.text = data!["mobile"] as? String
            self.addressTextField.text = data!["address"] as? String
            self.currentLocationTextField.text = data!["currentLocation"] as? String
            self.bloodTypeTextField.text = data!["blood"] as? String
            
            self.spinner.stopAnimating()
            
            self.view.addSubview(self.lineView)
            self.lineView.translatesAutoresizingMaskIntoConstraints = false
            self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
            self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
            
            self.view.addSubview(self.profileLabel)
            self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
            self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 22.0).isActive = true
            self.profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true

            self.view.addSubview(self.backButton)
            self.backButton.translatesAutoresizingMaskIntoConstraints = false
            self.backButton.isUserInteractionEnabled = true
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
            self.backButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            self.backButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            self.backButton.addTarget(self, action: #selector(self.back(_:)), for: .allEvents)
            
            self.view.addSubview(self.scrollView)
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
            
            self.scrollView.addSubview(self.nameTextField)
            self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
            self.nameTextField.isUserInteractionEnabled = true
            self.nameTextField.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10.0).isActive = true
            self.nameTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            self.nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            
            self.scrollView.addSubview(self.ageTextField)
            self.ageTextField.translatesAutoresizingMaskIntoConstraints = false
            self.ageTextField.isUserInteractionEnabled = true
            self.ageTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 10.0).isActive = true
            self.ageTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            self.ageTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            
            self.scrollView.addSubview(self.mobileTextField)
            self.mobileTextField.translatesAutoresizingMaskIntoConstraints = false
            self.mobileTextField.isUserInteractionEnabled = true
            self.mobileTextField.topAnchor.constraint(equalTo: self.ageTextField.bottomAnchor, constant: 10.0).isActive = true
            self.mobileTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            self.mobileTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            
            self.scrollView.addSubview(self.addressTextField)
            self.addressTextField.translatesAutoresizingMaskIntoConstraints = false
            self.addressTextField.isUserInteractionEnabled = true
            self.addressTextField.topAnchor.constraint(equalTo: self.mobileTextField.bottomAnchor, constant: 10.0).isActive = true
            self.addressTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            self.addressTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            
            self.scrollView.addSubview(self.currentLocationTextField)
            self.currentLocationTextField.translatesAutoresizingMaskIntoConstraints = false
            self.currentLocationTextField.isHidden = true
            self.currentLocationTextField.topAnchor.constraint(equalTo: self.addressTextField.bottomAnchor, constant: 10.0).isActive = true
            self.currentLocationTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            
            self.scrollView.addSubview(self.currentLocationBtn)
            self.currentLocationBtn.translatesAutoresizingMaskIntoConstraints = false
            self.currentLocationBtn.isUserInteractionEnabled = true
            self.currentLocationBtn.tintColor = .systemRed
            self.currentLocationBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
            self.currentLocationBtn.topAnchor.constraint(equalTo: self.addressTextField.bottomAnchor, constant: 10.0).isActive = true
            self.currentLocationBtn.addTarget(self, action: #selector(self.detectLocation(_:)), for: .touchUpInside)
            
            self.scrollView.addSubview(self.bloodTypeTextField)
            self.bloodTypeTextField.translatesAutoresizingMaskIntoConstraints = false
            self.bloodTypeTextField.isUserInteractionEnabled = true
            self.bloodTypeTextField.topAnchor.constraint(equalTo: self.currentLocationBtn.bottomAnchor, constant: 5.0).isActive = true
            self.bloodTypeTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            self.bloodTypeTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            
            self.scrollView.addSubview(self.signUpBtn)
            self.signUpBtn.translatesAutoresizingMaskIntoConstraints = false
            self.signUpBtn.isUserInteractionEnabled = true
            self.signUpBtn.topAnchor.constraint(equalTo: self.bloodTypeTextField.bottomAnchor, constant: 15.0).isActive = true
            self.signUpBtn.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
            self.signUpBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            self.signUpBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            self.signUpBtn.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -30.0).isActive = true
            self.signUpBtn.addTarget(self, action: #selector(self.update(_:)), for: .touchUpInside)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        currentLocationTextField.text = "\(location)"
        currentLocationBtn.setTitle("Location updated", for: .normal)
        let alert = UIAlertController(title: "Success", message: "Location updated successfully.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        locationManager.stopUpdatingLocation()
    }
    
}
