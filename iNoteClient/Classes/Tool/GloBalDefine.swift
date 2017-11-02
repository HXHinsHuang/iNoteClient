//
//  GloBalDefine.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit


func getViewControllerFromMainStoryboard(withIdentifier: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: withIdentifier)
}

class INoteController {
    static let iNoteLoginNav = "iNoteLoginNav"
    static let INoteEditController = "INoteEditController"
}
