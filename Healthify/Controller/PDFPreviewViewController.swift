//
//  PDFPreviewViewController.swift
//  Healthify
//
//  Created by Himanshu Joshi on 03/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    public var documentData: Data?
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }

    }
    


}
