//
//  ForgotPassVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 25/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class ForgotPassVC: UIViewController {
    
    var emailArray = [String]()
    
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
        label.text = "RESET PASSWORD"
        label.font = UIFont(name: "Avenir-Medium", size: 18.0)
        label.textColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
    let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Email"
        textField.selectedTitleColor = .black
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let resetPassBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RESET PASSWORD", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.tintColor = .black
        return button
    }()
    
    @objc func resetPass(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter the email.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.spinner.startAnimating()
        
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
            if !self.emailArray.contains(self.emailTextField.text!) {
                self.spinner.stopAnimating()
                let alert = UIAlertController(title: "Error", message: "This email do not corresponds to our database. Please check your email.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                Auth.auth().sendPasswordReset(withEmail: (self.emailTextField.text)!) { (error) in
                    if let error = error {
                        self.spinner.stopAnimating()
                        print("Error while sending reset link, \(error.localizedDescription)")
                        return
                    } else {
                        self.spinner.stopAnimating()
                        let alert = UIAlertController(title: "Success", message: "Password reset link has been sent to your Gmail. Please reset your password and then login.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

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

        self.view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.isUserInteractionEnabled = true
        emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        
        self.view.addSubview(resetPassBtn)
        resetPassBtn.translatesAutoresizingMaskIntoConstraints = false
        resetPassBtn.isUserInteractionEnabled = true
        resetPassBtn.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 25.0).isActive = true
        resetPassBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        resetPassBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        resetPassBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        resetPassBtn.addTarget(self, action: #selector(resetPass(_:)), for: .touchUpInside)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func disissKeyboard() {
        view.endEditing(true)
    }
    

}
