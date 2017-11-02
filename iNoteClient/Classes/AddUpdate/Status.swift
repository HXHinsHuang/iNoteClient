//
//  Status.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import RxSwift

enum Status {
    case none
    case add
    case modify
}

extension Status {
    var title: String {
        switch self {
        case .none:
            return ""
        case .add:
            return "添加笔记"
        case .modify:
            return "修改笔记"
        }
    }
    
    var btnText: String {
        switch self {
        case .none:
            return "done"
        case .add:
            return "添加"
        case .modify:
            return "修改"
        }
    }
    
    var rxStatus: Observable<Status> {
        return Observable.create({ (observe) -> Disposable in
            observe.onNext(self)
            observe.onCompleted()
            return Disposables.create()
        })
    }
}
