//
//  LoginResponse.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/25.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation

struct LoginResponse: Codable, CustomStringConvertible {
    let status: String
    let message: String
    let result: Bool
    let data: [LoginData]
    
    var description: String {
        return """
        LoginResponse: {
            status: \(status)
            message: \(message)
            result: \(result)
            data: \(data)
        }
        """
    }
}

struct LoginData: Codable, CustomStringConvertible {
    let userId: String
    let phoneNum: String
    let registerTime: String
    
    var description: String {
        return """
        LoginData : {
            userId: \(userId)
            phoneNum: \(phoneNum)
            registerTime: \(registerTime)
        }
        """
    }
}

let errorLoginResponse = LoginResponse(status: "FAILURE", message: "请求失败", result: false, data: [])
