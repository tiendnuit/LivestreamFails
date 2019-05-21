//
//  VideoPostPresentable.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit

protocol VideoPostPresentable {
    var titleLabel: UILabel! {set get}
    var timeLabel: UILabel! {set get}
    var scoreLabel: UILabel! {set get}
}

extension VideoPostPresentable {
    func map(post: VideoPost?) {
        guard let post = post else { return }
        titleLabel.text = post.title
        timeLabel.text = post.time
        scoreLabel.text = post.score
        
    }
}
