//
//  AppDefined.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit

struct AppDefined {
    
    static func getStringValue(key: String) -> String {
        guard let info = Bundle.main.infoDictionary else { return ""}
        return info[key] as? String ?? ""
    }
    
    struct API {
        static var BaseUrl: String {
            return getStringValue(key: "LiveStreamFailsBaseURL")
        }
        
        static let ITEMS_PER_PAGE = 20
    }

}
