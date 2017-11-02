//
//  AccountManager.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/27.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation

class AccountManager {
    static let instance = AccountManager()
    var userId: String?
    var phoneNum: String?
    var registerTime: String?
    
    var savePassword: Bool = false
    var autoLogin: Bool = false
    
    var logined: Bool = false
    
    private init() {}

    func setUserInfo(_ info: LoginData) {
        userId = info.userId
        phoneNum = info.phoneNum
        registerTime = info.registerTime
        login()
    }
    
    private func login() {
        logined = true
        if let phoneNum = phoneNum {
            UserDefaults.standard.set(phoneNum, forKey: "phoneNum")
            UserDefaults.standard.synchronize()
        }
    }
    
    func loginOut() {
        userId = nil
        phoneNum = nil
        registerTime = nil
        logined = false
    }
}



