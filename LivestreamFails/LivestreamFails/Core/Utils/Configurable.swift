//
//  Configurable.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation

protocol Configurable {
    func configure(item: Any)
}

protocol UIViewControllerConfigurable {
    func setupComponents()
    func bindViewModel()
    func updateUI()
}
