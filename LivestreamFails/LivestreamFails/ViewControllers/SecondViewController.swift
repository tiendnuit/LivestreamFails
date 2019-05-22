//
//  SecondViewController.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var likes: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        guard let button = sender as? LikeButton else { return }
//        var frame = button.frame
//        let borderView = UIView(frame: frame)
//        borderView.layer.cornerRadius = frame.size.height/2
//        borderView.layer.masksToBounds = true
//        borderView.backgroundColor = R.color.lsOrange()
//        view.insertSubview(borderView, belowSubview: button)
//        UIView.animate(withDuration: 0.3, animations: {
//            frame.size.width = 150
//            frame.size.height = 150
//            borderView.frame = frame
//            borderView.center = button.center
//            borderView.alpha = 0
//            borderView.layer.cornerRadius = frame.size.height/2
//        }) { (_) in
//            borderView.removeFromSuperview()
//        }
        likes += 1
        button.animatedFloatLabel(count: likes)
    }
    
}

