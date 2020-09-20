//
//  ChatCell.swift
//  Healthify
//
//  Created by Himanshu Joshi on 16/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var nameLabel: UILabel!
}
