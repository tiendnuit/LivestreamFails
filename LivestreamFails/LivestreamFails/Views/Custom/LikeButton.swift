//
//  LikeButton.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/22/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LikeButton: UIButton {

    @IBInspectable open var animationColor: UIColor = R.color.lsOrange()!
    @IBInspectable open var duration: Double = 0.3
    @IBInspectable open var floatLabelDuration: Double = 0.8
    @IBInspectable open var maxRadiusRate: CGFloat = 2
    @IBInspectable open var animationDistance: CGFloat = 200
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func animatedBorderView() {
        var frame = self.frame
        let newWidth = frame.width*maxRadiusRate
        let borderView = UIView(frame: frame)
        borderView.layer.cornerRadius = frame.size.height/2
        borderView.layer.masksToBounds = true
        borderView.backgroundColor = animationColor
        superview?.insertSubview(borderView, belowSubview: self)
        UIView.animate(withDuration: duration, animations: {
            frame.size.width = newWidth
            frame.size.height = newWidth
            borderView.frame = frame
            borderView.center = self.center
            borderView.alpha = 0
            borderView.layer.cornerRadius = frame.size.height/2
        }) { (_) in
            borderView.removeFromSuperview()
        }
    }
    
    func animatedFloatLabel(count: Int) {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.LSFonts.boldS20
        label.text = "+\(count)"
        label.textColor = UIColor.random
        label.frame = bounds
        label.center = center
        let newCenter = CGPoint(x: center.x, y: center.y - animationDistance)
        superview?.insertSubview(label, belowSubview: self)
        UIView.animate(withDuration: floatLabelDuration, animations: {
            label.center = newCenter
            label.alpha = 0
        }) { (_) in
            label.removeFromSuperview()
        }
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        animatedBorderView()
        super.sendAction(action, to: target, for: event)
    }
}
