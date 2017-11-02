//
//  RegisterResponse.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/25.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation

struct RegisterResponse: Codable {
    let status: String
    let message: String
    let result: Bool
}

extension RegisterResponse: CustomStringConvertible {
    var description: String {
        return """
        RegisterResponse: {
            status: \(status)
            message: \(message)
            result: \(result)
        }
        """
    }
}

let errorRegisterResponse = RegisterResponse(status: "FAILURE", message: "请求失败", result: false)
