//
//  AddItemVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 06/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SkyFloatingLabelTextField
import FirebaseAuth
import OpalImagePicker

class AddItemVC: UIViewController, UITextViewDelegate, OpalImagePickerControllerDelegate {
    
    var profileImageUrl = [String]()
    var trackerInt: Int = 0
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back.png"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    @objc func back(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        label.text = "Add Item"
        label.font = UIFont(name: "Avenir-Medium", size: 22.0)
        label.textColor = .black
        return label
    }()
    
    let nameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Item name"
        textField.font = UIFont(name: "Avenir-Medium", size: 20.0)
        return textField
    }()
    
    let descTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Description of the item."
        textView.textColor = .lightGray
        textView.layer.borderWidth = 1.0
        textView.font = UIFont(name: "Avenir-Medium", size: 20.0)
        textView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return textView
    }()
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.descTextView.text = ""
        self.descTextView.textColor = .black
        return true
    }
    
    let priceTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Item price"
        textField.font = UIFont(name: "Avenir-Medium", size: 20.0)
        return textField
    }()
    
    let quantityTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.font = UIFont(name: "Avenir-Medium", size: 20.0)
        textField.placeholder = "Item quantity"
        return textField
    }()
    
    let addPhotosLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photos"
        label.font = UIFont(name: "Avenir-Medium", size: 20.0)
        label.textColor = .black
        return label
    }()
    
    let uploadBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "paperclip.png"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ADD ITEM", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.tintColor = .black
        return button
    }()
    
    @objc func saveItem(_: UIButton) {
        
        guard let name = nameTextField.text, let desc = descTextView.text, let price = priceTextField.text, let quantity = quantityTextField.text else { return }
        
        if name == "" || desc == "" || price == "" || quantity == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        } else {
            Firestore.firestore().collection("Items").addDocument(data: [
                "itemName" : name,
                "itemDesc" : desc,
                "itemPrice" : price,
                "itemQuantity" : quantity,
                "photoUrl" : profileImageUrl,
                "userEmail" : (Auth.auth().currentUser?.email)!
            ]) { (error) in
                if let error = error {
                    print("Error setting data, \(error)")
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descTextView.text = "Description of the Item"
        descTextView.delegate = self
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isUserInteractionEnabled = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.addTarget(self, action: #selector(back(_:)), for: .allEvents)
        
        self.view.addSubview(self.lineView)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(self.profileLabel)
        self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
        self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        self.descTextView.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.topAnchor.constraint(equalTo: self.descTextView.topAnchor, constant: 150.0).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.descTextView.centerXAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 61.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        self.scrollView.addSubview(self.nameTextField)
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.nameTextField.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10.0).isActive = true
        self.nameTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10.0).isActive = true
        self.nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        
        self.scrollView.addSubview(descTextView)
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10.0).isActive = true
        descTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        descTextView.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 10.0).isActive = true
        descTextView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        self.scrollView.addSubview(self.priceTextField)
        self.priceTextField.translatesAutoresizingMaskIntoConstraints = false
        self.priceTextField.topAnchor.constraint(equalTo: self.descTextView.bottomAnchor, constant: 10.0).isActive = true
        self.priceTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10.0).isActive = true
        self.priceTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        
        self.scrollView.addSubview(self.quantityTextField)
        self.quantityTextField.translatesAutoresizingMaskIntoConstraints = false
        self.quantityTextField.topAnchor.constraint(equalTo: self.priceTextField.bottomAnchor, constant: 10.0).isActive = true
        self.quantityTextField.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10.0).isActive = true
        self.quantityTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        
        
        self.scrollView.addSubview(self.addPhotosLabel)
        addPhotosLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotosLabel.topAnchor.constraint(equalTo: self.quantityTextField.bottomAnchor, constant: 10.0).isActive = true
        addPhotosLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10.0).isActive = true
        
        self.scrollView.addSubview(uploadBtn)
        uploadBtn.translatesAutoresizingMaskIntoConstraints = false
        uploadBtn.isUserInteractionEnabled = true
        uploadBtn.centerYAnchor.constraint(equalTo: self.addPhotosLabel.centerYAnchor, constant: 0.0).isActive = true
        uploadBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        uploadBtn.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        uploadBtn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        uploadBtn.addTarget(self, action: #selector(handleProfileImageView(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(saveBtn)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.isUserInteractionEnabled = true
        saveBtn.topAnchor.constraint(equalTo: self.addPhotosLabel.bottomAnchor, constant: 15.0).isActive = true
        saveBtn.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10.0).isActive = true
        saveBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 47.0).isActive = true
        saveBtn.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -30.0).isActive = true
        saveBtn.addTarget(self, action: #selector(saveItem(_:)), for: .touchUpInside)
    }
    
    
}

extension AddItemVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleProfileImageView(_ sender: UIButton) {
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 5
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        self.dismiss(animated: true) {
            self.profileImageUrl.removeAll()
            self.saveBtn.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
            for selectedImage in images {
                let imageName = String("\((Auth.auth().currentUser?.uid)!)" + "\(Date().timeIntervalSince1970 * 1000)" + ".jpg")
                let storageRef = Storage.storage().reference().child(imageName)
                if let uploadData = selectedImage.jpegData(compressionQuality: 0.1) {
                    storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                        if let error = error {
                            print("Error uploading images to firebase storage, \(error.localizedDescription)")
                        }
                        storageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("Could not download url, \(error.localizedDescription)")
                            }
                            self.profileImageUrl.append(url!.absoluteString)
                            if ((images.count) == (self.profileImageUrl.count)) {
                                self.activityIndicator.stopAnimating()
                                self.saveBtn.isUserInteractionEnabled = true
                            }
                        }
                         
                    }
                }
                
            }
        }
    }

//    @objc func handleProfileImageView(_ sender : UIButton) {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            presentPhotoPicker(sourceType: .photoLibrary)
//            return
//        }
//
//        let photoSourcePicker = UIAlertController()
//        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
//            self.presentPhotoPicker(sourceType: .camera)
//        }
//
//        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
//            self.presentPhotoPicker(sourceType: .photoLibrary)
//        }
//
//        photoSourcePicker.addAction(takePhotoAction)
//        photoSourcePicker.addAction(choosePhotoAction)
//        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(photoSourcePicker, animated: true, completion: nil)
//    }
//
//    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = sourceType
//        picker.allowsEditing = true
//        present(picker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
//            selectedImageFromPicker = originalImage
//        }
//
//        selectedImage = selectedImageFromPicker
//        dismiss(animated: true, completion: nil)
//
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }

}


