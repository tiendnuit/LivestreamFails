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
    var departCodeLabel: UILabel! {set get}
    var departTimeLabel: UILabel! {set get}
    var arrivalCodeLabel: UILabel! {set get}
    var arrivalTimeLabel: UILabel! {set get}
}

extension VideoPostPresentable {
    func map(post: VideoPost?) {
        guard let flight = flight else { return }
        
        flightNoLabel.textColor = UIColor.BodaColors.green
        flightNoLabel.text = "\(flight.number)"
        durationLabel.text = flight.duration
        departCodeLabel.text = flight.departureCode
        arrivalCodeLabel.text = flight.arrivalCode
        departTimeLabel.text = flight.departureTime?.toString(dateFormat: "hh:mma")
        arrivalTimeLabel.text = flight.arrivalTime?.toString(dateFormat: "hh:mma")
    }
}
