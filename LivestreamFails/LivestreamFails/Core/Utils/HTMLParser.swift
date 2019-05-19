//
//  HTMLParser.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import SwiftSoup

struct HTMLParser {
    public static func getPosts(htmlString: String) throws -> [VideoPost] {
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let postElements = try doc.select("div.post-card")
            let posts = postElements.compactMap { VideoPost(element: $0) }
            return posts
        } catch {
            throw LSFailsError.InvalidHTML
        }
    }
}
