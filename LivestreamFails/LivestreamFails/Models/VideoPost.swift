//
//  VideoPost.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import SwiftSoup
import Moya

struct VideoPost {
    let id: String
    let title: String
    let content: String     // video url
    
    let thumbnail: String?
    let score: String?
    let time: String?
    let streamerName: String?
    let gameName: String?
    
    
    init?(element: Element) {
        guard let id = try? element.attr("id"),
            let title = try? element.attr("data-title"),
            let content = try? element.attr("data-content") else {
                return nil
        }
        self.id = id
        self.title = title
        self.content = content
        thumbnail = try? element.attr("data-thumbnail")
        score = try? element.attr("data-score")
        time = try? element.attr("data-time")
        streamerName = try? element.attr("data-streamer_name")
        gameName = try? element.attr("data-game_name")
    }
}

extension Moya.Response {
    func mapPosts() throws -> [VideoPost] {
        if let htmlString = String(data: data, encoding: .utf8) {
            do {
                let posts = try HTMLParser.getPosts(htmlString: htmlString)
                return posts
            } catch {
                throw MoyaError.jsonMapping(self)
            }
        }
        
        
        throw MoyaError.jsonMapping(self)
    }
}
