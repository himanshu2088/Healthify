//
//  CameraVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 27/07/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import PDFKit
import VisionKit
import Vision

class CameraVC: UIViewController {
    
    var requests = [VNRequest]()
    let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var resultingText = ""
    var image: UIImage?
    
    let addBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add.png"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back.png"), for: .normal)
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
        label.text = "Add documents"
        label.font = UIFont(name: "Avenir-Medium", size: 22.0)
        label.textColor = .black
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
    let saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE AS PDF", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0, alpha: 1)
        button.tintColor = .black
        return button
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: "Avenir", size: 20.0)
        return view
    }()

    @objc func saved(_ sender: UIButton) {
        if textView.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please scan something to make a PDF.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        } else {
            let pdfCreator = PDFCreator(body: textView.text)
            let pdfData = pdfCreator.createFlyer()
            let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewSegue" {
        guard let vc = segue.destination as? PDFPreviewViewController else { return }
        
        if let body = textView.text {
          let pdfCreator = PDFCreator(body: body)
          vc.documentData = pdfCreator.createFlyer()
        }
      }
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    private func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
    
    @objc func addDocument(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }

        let photoSourcePicker = UIAlertController()

        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true)
        }

        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }

        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosePhotoAction)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(photoSourcePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVision()
        
        self.textView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.textView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.textView.centerXAnchor).isActive = true
        
        self.view.addSubview(self.lineView)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isUserInteractionEnabled = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        backButton.addTarget(self, action: #selector(back(_:)), for: .allEvents)
        
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
        
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70.0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        textView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200.0).isActive = true
        
        self.view.addSubview(saveBtn)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.isUserInteractionEnabled = true
        saveBtn.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 10.0).isActive = true
        saveBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0).isActive = true
        saveBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 47.0).isActive = true
        saveBtn.addTarget(self, action: #selector(saved(_:)), for: .touchUpInside)
        
    }

}

extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("No images returned") }
        spinner.startAnimating()
        textRecognitionWorkQueue.async {
            self.resultingText = ""
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
            DispatchQueue.main.async {
                self.textView.text = self.resultingText
                self.spinner.stopAnimating()
            }
            
        }
        
    }
    
    
}

extension CameraVC: VNDocumentCameraViewControllerDelegate {
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true, completion: nil)
        spinner.startAnimating()
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
                self.resultingText += "\n\n"
            }
            DispatchQueue.main.async {
                self.textView.text = self.resultingText
                self.spinner.stopAnimating()
            }
        }
    }
    
}

