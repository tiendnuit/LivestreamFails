//
//  LiveStreamFailsAPI.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import Moya

let liveStreamFailsAPI = MoyaProvider<LiveStreamFailsAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
// MARK: - Provider setup
public enum LiveStreamFailsAPI {
    case loadPosts(PaginationInfo)
    case getPost(String)
}

extension LiveStreamFailsAPI: TargetType {
    public var baseURL: URL {
        let path = AppDefined.API.BaseUrl
        return URL(string: path)!
    }
    public var path: String {
        switch self {
        case .loadPosts:
            return "/load/loadPosts.php"
        case .getPost(let postId):
            return "/post/\(postId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .loadPosts(let paginationInfo):
            return .requestParameters(parameters: paginationInfo.params, encoding: parameterEncoding)
            
        default:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
