//
//  AppDelegate.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/22.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        globalConfigure()
        
        return true
    }
    
}

extension AppDelegate {

    func globalConfigure() {
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
}

