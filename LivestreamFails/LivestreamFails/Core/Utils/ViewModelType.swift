//
//  ViewModelType.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
