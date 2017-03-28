//
//  MessageTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 28.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, MessageCellConfiguration {
    
    // Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBack: UIView!
    @IBOutlet weak var ident: NSLayoutConstraint!
    

    // Prorerties
    var textt: String? {
        willSet {
            self.messageLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBack.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
