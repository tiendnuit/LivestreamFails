//
//  PaginationInfo.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation

public struct PaginationInfo {
    var page: Int = 0
    
    var params: [String: Any] {
        return ["loadPostPage": page,
                "loadPostMode": "standard",
                "loadPostOrder": "hot",
                "loadPostTimeFrame": "all",
                "loadPostNSFW": 0]
    }
    
    init(page: Int = 0) {
        self.page = page
    }
    
    static let `default` = PaginationInfo(page: 0)
}
