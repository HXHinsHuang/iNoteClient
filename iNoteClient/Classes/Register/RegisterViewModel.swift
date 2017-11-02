//
//  RegisterViewModel.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/22.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel {
    let registerBtnEnable: Driver<Bool>
    let response: Driver<RegisterResponse>
    init(input: (phoneNum: Driver<String>, password: Driver<String>, registerTap: Driver<Void>)) {
        let phoneNumAndPassword = Driver.combineLatest(input.phoneNum, input.password, resultSelector: {($0,$1)})
        registerBtnEnable = phoneNumAndPassword.map { $0.count > 0 && $1.count > 0 }.asDriver()
        response = input.registerTap
            .throttle(1.5)
            .withLatestFrom(phoneNumAndPassword)
            .flatMapLatest { (phoneNumStr, passwordStr) in
                AppNetworkProvider.rx
                    .request(.register(phoneNum: phoneNumStr, password: passwordStr))
                    .filterSuccessfulStatusCodes()
                    .map(RegisterResponse.self)
                    .asDriver(onErrorJustReturn: errorRegisterResponse)
        }
    }
}
