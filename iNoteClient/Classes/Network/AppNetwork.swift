//
//  AppNetwork.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/25.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import Moya

let AppNetworkProvider = MoyaProvider<AppNetwork>()

enum AppNetwork {
    case register(phoneNum: String, password: String)
    case login(phoneNum: String, password: String)
    case contentList(userId: String)
    case addNote(userId: String, title: String, content: String)
    case deleteNote(id: String)
    case modifyNote(id: String, title: String, content: String)
}

let baseUrlStr = "http://0.0.0.0:8181/iNote"

extension AppNetwork: TargetType {
    /// The target's base `URL`.
    var baseURL: URL { return URL(string: baseUrlStr)! }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .contentList:
            return "/contentList"
        case .addNote:
            return "/addNote"
        case .deleteNote:
            return "/deleteNote"
        case .modifyNote:
            return "/modifyNote"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .login:
            return .post
        case .contentList:
            return .get
        case .addNote:
            return .post
        case .deleteNote:
            return .delete
        case .modifyNote:
            return .post
        }
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { return "".data(using: .utf8)! }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case .register(phoneNum: let phone, password: let pwd):
            let params = ["phoneNum": phone, "password": pwd]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .login(phoneNum: let phone, password: let pwd):
            let params = ["phoneNum": phone, "password": pwd]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .contentList(let userId):
            let params = ["userId": userId]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .addNote(let userId, let title, let content):
            let params = ["userId": userId, "title": title, "content": content]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .deleteNote(let id):
            let params = ["id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .modifyNote(let id, let title, let content):
            let params = ["id": id, "title": title, "content": content]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { return nil }
}
