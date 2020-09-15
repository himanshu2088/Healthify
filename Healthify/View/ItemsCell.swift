//
//  ItemsCell.swift
//  Healthify
//
//  Created by Himanshu Joshi on 09/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit

class ItemsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBAction func photosBtn(_ sender: UIButton) {
    }
    
    @IBAction func contactBtn(_ sender: UIButton) {
    }
}
