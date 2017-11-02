//
//  INoteEditViewModel.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class INoteEditViewModel {
    let doneBtnEnable: Driver<Bool>
    init(input: (title: Driver<String>, content: Driver<String>)) {
        let titleContent = Driver.combineLatest(input.title, input.content, resultSelector: {($0,$1)})
        doneBtnEnable = titleContent.map{$0.0.count > 0 && $0.1.count > 0}
            
    }
}
