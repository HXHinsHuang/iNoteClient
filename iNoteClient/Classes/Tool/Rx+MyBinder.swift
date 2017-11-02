//
//  Rx+MyBinder.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {
    var enableAlpha: Binder<Bool> {
        return Binder(self.base) { btn, enable in
            btn.alpha = enable ? 1.0 : 0.6
        }
    }
}


