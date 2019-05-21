//
//  StoryCollectionViewCell.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/22/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class StoryCollectionViewCell: UICollectionViewCell, Configurable {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarContainerView: UIView!
    
    private var gradientLayer: CAGradientLayer = {
        let color = UIColor.random
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.cornerRadius = 10
        return gradientLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        avatarContainerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = avatarContainerView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
    }
    
    func configure(item: Any) {
        guard let item = item as? Story else { return }
        usernameLabel.text = item.username
        
        avatarImageView.sd_setImage(with: URL(string: item.avatar), completed: nil)
    }
}
