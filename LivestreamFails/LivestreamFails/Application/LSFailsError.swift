//
//  LSFailsError.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation

struct LSFailsError: Swift.Error, LocalizedError {
    var code: Int
    var message: String
    
    static let ERROR_TITLE = "Error"
    static var InvalidHTML = LSFailsError(code: 0, message: "LSFailsError.InvalidHTML")
    static var Unknown = BodaError(code: 0, message: "LSFailsError.Unknown")
    var errorDescription: String? {
        return message
    }
    
    static func error(_ error: Error) -> LSFailsError {
        return LSFailsError(code: 0, message: error.localizedDescription)
    }
}
