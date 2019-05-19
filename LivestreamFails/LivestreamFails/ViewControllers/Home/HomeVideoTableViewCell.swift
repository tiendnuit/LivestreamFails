//
//  HomeVideoTableViewCell.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit

class HomeVideoTableViewCell: UITableViewCell, Configurable {

    func configure(item: Any) {
        map(airport: item as? Airport)
    }
}
