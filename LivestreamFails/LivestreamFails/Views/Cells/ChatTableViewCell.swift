//
//  ChatTableViewCell.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/22/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit

class ChatTableViewCell: UITableViewCell, Configurable {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(item: Any) {
        guard let item = item as? Message else { return }
        usernameLabel.text = item.username
        contentLabel.text = item.content
    }
}
