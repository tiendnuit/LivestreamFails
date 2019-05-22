//
//  HomeVideoTableViewCell.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AVKit
import AVFoundation

class HomeVideoTableViewCell: UITableViewCell, Configurable, VideoPostPresentable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var likeButton: LikeButton!
    
    
    let disposeBag = DisposeBag()
    var results = Variable<[Message]>([])
    var video: VideoPost?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(R.nib.chatTableViewCell)
        tableView.rowHeight = 30
        
        results.asDriver().drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatTableViewCell, for: indexPath) as ChatTableViewCell?
            cell?.configure(item: item)
            
            return cell!
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] notification in
            self?.playerView.player?.seek(to: CMTime.zero)
            self?.play()
        }
    }

    func configure(item: Any) {
        guard let item = item as? VideoPost else { return }
        video = item
        map(post: item)
        let messages = [Message(username: "drg5", content: "just like this 100times"),
                        Message(username: "ninja", content: "😀 😀 😀 😀 😀 😀"),
                        Message(username: "yuieirooo", content: "how do you even do that?"),
                        Message(username: "drg5", content: "just like this 100times"),
                        Message(username: "drg5", content: "just like this 100times"),
                        Message(username: "drg5", content: "just like this 100times")]
        results.value = messages
        
        //setup player
        if let url = URL(string: item.content) {
            let avPlayer = AVPlayer(url: url)
            playerView.playerLayer.player = avPlayer
        } else {
            playerView.playerLayer.player = nil
        }
        playerView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func play() {
        playerView.player?.play()
    }
    
    func stop() {
        playerView.player?.pause()
        playerView.player = nil
    }
    
    func pause() {
        playerView.player?.pause()
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        video?.like += 1
        let likes = video?.like ?? 0
        likeButton.animatedFloatLabel(count: likes)
    }
    
}
