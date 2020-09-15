//
//  PDFCreator.swift
//  Healthify
//
//  Created by Himanshu Joshi on 03/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
  let body: String
  
  init(body: String) {
    self.body = body
  }
  
  func createFlyer() -> Data {
    // 1
    let pdfMetaData = [
      kCGPDFContextCreator: "Healthify"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    // 2
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    // 3
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    // 4
    let data = renderer.pdfData { (context) in
      context.beginPage()
      addBodyText(pageRect: pageRect, textTop: 18.0)
    
    }
    
    return data
  }

  func addBodyText(pageRect: CGRect, textTop: CGFloat) {
    // 1
    let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 2
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    // 3
    let textAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: textFont
    ]
    let attributedText = NSAttributedString(string: body, attributes: textAttributes)
    // 4
    let textRect = CGRect(x: 10, y: textTop, width: pageRect.width - 20,
                          height: pageRect.height - textTop - pageRect.height / 5.0)
    attributedText.draw(in: textRect)
  }

}
