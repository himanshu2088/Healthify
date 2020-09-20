//
//  SignUpVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 25/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import CoreLocation
import FirebaseDatabase

class SignUpVC: UIViewController, CLLocationManagerDelegate {
    
    var emailArray = [String]()
    let locationManager = CLLocationManager()
    var location : CLLocation?
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "SIGNUP"
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
        button.setTitle("Detect", for: .normal)
        return button
    }()
    
    let bloodTypeTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Blood group*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Email*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let passTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Password*"
        textField.selectedTitleColor = .black
        return textField
    }()
    
    let confirmPassTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Confirm password*"
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
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.tintColor = .black
        return button
    }()
    
    @objc func signUp(_ sender: UIButton) {
        
        spinner.startAnimating()

        guard let name = nameTextField.text, let age = ageTextField.text, let mobile = nameTextField.text, let address = addressTextField.text, let bloodType = bloodTypeTextField.text, let email = emailTextField.text, let password = passTextField.text, let confirmPass = confirmPassTextField.text else { return }
        
        if name == "" || age == "" || mobile == "" || address == "" || bloodType == "" || email == "" || password == "" || confirmPass == "" {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Please enter all the mandatory fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else if password != confirmPass {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Entered password and confirm password are not equal. Please write same details.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else if location == nil {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Location could not fetched. Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
            
        else if password.count <= 5 {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Password must be 6 letters or more than 6 letters long.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else {
            Firestore.firestore().collection("Donors").getDocuments { (snapshot, error) in
                if let error = error {
                    self.spinner.stopAnimating()
                    print(error.localizedDescription)
                }
                let documents = snapshot?.documents
                for document in documents! {
                    let data = document.data()
                    let usedEmail = data["email"] as? String ?? ""
                    self.emailArray.append(usedEmail)
                }
                if self.emailArray.contains(email) {
                    self.spinner.stopAnimating()
                    let alert = UIAlertController(title: "Error", message: "Email is already taken. Please try another one.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.saveData()
                }

            }
        }
    }
    
    func saveData() {
        
        guard let name = nameTextField.text, let age = ageTextField.text, let mobile = mobileTextField.text, let address = addressTextField.text, let currentLocation = currentLocationTextField.text, let bloodType = bloodTypeTextField.text, let email = emailTextField.text, let password = passTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error creating user, \(error.localizedDescription)")
            }
            guard let userId = user?.user.uid else { return }
            Firestore.firestore().collection("Donors").document(userId).setData([
                "name" : name,
                "age" : age,
                "mobile" : mobile,
                "address" : address,
                "currentLocation" : "\(self.location!)",
                "blood" : bloodType,
                "email" : email,
                "password" : password
            ]) { (error) in
                if let error = error {
                    print("Error setting data of createUser, \(error.localizedDescription)")
                } else {
                    let currentUser = Auth.auth().currentUser
                    
                    let reference  = Database.database().reference().child("users").child(currentUser!.uid)
                    let values = ["email" : email, "name" : name] as [String : Any]
                    reference.updateChildValues(values) { (error, ref) in
                        print("Updated data in firebase realtime database")
                    }
                    
                    currentUser?.sendEmailVerification(completion: { (error) in
                        if let error = error {
                            print("Error while sending email verification, \(error.localizedDescription)")
                        } else {
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Success", message: "Account created successfully. Check your Gmail to verify your account. An email verification link is sent there.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 22.0).isActive = true
        profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true

        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isUserInteractionEnabled = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.addTarget(self, action: #selector(back(_:)), for: .allEvents)
        
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.scrollView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.isUserInteractionEnabled = true
        nameTextField.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10.0).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(ageTextField)
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.isUserInteractionEnabled = true
        ageTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 10.0).isActive = true
        ageTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        ageTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(mobileTextField)
        mobileTextField.translatesAutoresizingMaskIntoConstraints = false
        mobileTextField.isUserInteractionEnabled = true
        mobileTextField.topAnchor.constraint(equalTo: self.ageTextField.bottomAnchor, constant: 10.0).isActive = true
        mobileTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        mobileTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(addressTextField)
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTextField.isUserInteractionEnabled = true
        addressTextField.topAnchor.constraint(equalTo: self.mobileTextField.bottomAnchor, constant: 10.0).isActive = true
        addressTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        addressTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(currentLocationTextField)
        currentLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        currentLocationTextField.topAnchor.constraint(equalTo: self.addressTextField.bottomAnchor, constant: 10.0).isActive = true
        currentLocationTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        
        self.scrollView.addSubview(currentLocationBtn)
        currentLocationBtn.translatesAutoresizingMaskIntoConstraints = false
        currentLocationBtn.isUserInteractionEnabled = true
        currentLocationBtn.tintColor = .systemRed
        currentLocationBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        currentLocationBtn.centerYAnchor.constraint(equalTo: self.currentLocationTextField.centerYAnchor, constant: 0.0).isActive = true
        currentLocationBtn.addTarget(self, action: #selector(detectLocation(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(bloodTypeTextField)
        bloodTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        bloodTypeTextField.isUserInteractionEnabled = true
        bloodTypeTextField.topAnchor.constraint(equalTo: self.currentLocationBtn.bottomAnchor, constant: 5.0).isActive = true
        bloodTypeTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        bloodTypeTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.isUserInteractionEnabled = true
        emailTextField.topAnchor.constraint(equalTo: self.bloodTypeTextField.bottomAnchor, constant: 10.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(passTextField)
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.isUserInteractionEnabled = true
        passTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        passTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(confirmPassTextField)
        confirmPassTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPassTextField.isUserInteractionEnabled = true
        confirmPassTextField.topAnchor.constraint(equalTo: self.passTextField.bottomAnchor, constant: 10.0).isActive = true
        confirmPassTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        confirmPassTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.scrollView.addSubview(signUpBtn)
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.topAnchor.constraint(equalTo: self.confirmPassTextField.bottomAnchor, constant: 15.0).isActive = true
        signUpBtn.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20.0).isActive = true
        signUpBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        signUpBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        signUpBtn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30.0).isActive = true
        signUpBtn.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func disissKeyboard() {
        view.endEditing(true)
    }
    
    //Core Location Methods
    
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
        currentLocationTextField.text = "Detected"
        locationManager.stopUpdatingLocation()
    }

}
