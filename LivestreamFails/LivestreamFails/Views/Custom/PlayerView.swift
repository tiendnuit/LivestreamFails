//
//  PlayerView.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/22/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}
