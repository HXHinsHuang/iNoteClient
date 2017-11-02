//
//  LoginViewModel.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/22.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    let loginBtnEnable: Driver<Bool>
    let response: Driver<LoginResponse>
    init(input: (phoneNum: Driver<String>, password: Driver<String>, loginTap: Driver<()>)) {
        let phoneNumAndPassword = Driver.combineLatest(input.phoneNum, input.password) { ($0,$1) }
        loginBtnEnable = phoneNumAndPassword.map { $0.count > 0 && $1.count > 0 }.asDriver()
        response = input.loginTap
            .throttle(1.5)
            .withLatestFrom(phoneNumAndPassword)
            .flatMapLatest { (phoneNumStr, passwordStr) in
                AppNetworkProvider.rx
                    .request(.login(phoneNum: phoneNumStr, password: passwordStr))
                    .map(LoginResponse.self)
                    .asDriver(onErrorJustReturn: errorLoginResponse)
        }
    }
}
