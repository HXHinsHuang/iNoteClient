//
//  LoginController.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/22.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

class LoginController: UIViewController {

    @IBOutlet weak var phoneNumTF: UITextField! {
        didSet {
            if let phoneNum = UserDefaults.standard.string(forKey: "phoneNum") {
                phoneNumTF.text = phoneNum
            }
        }
    }
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.layer.cornerRadius = 8
            loginBtn.layer.masksToBounds = true
        }
    }
    
    private lazy var loginVM: LoginViewModel = {
        let pnDri = phoneNumTF.rx.text.orEmpty.asDriver()
        let pwdDri = passwordTF.rx.text.orEmpty.asDriver()
        let logBtnDri = loginBtn.rx.tap.asDriver()
        return LoginViewModel(input: (pnDri, pwdDri, logBtnDri))
    }()
    
    private let disposeBag = DisposeBag()
    
}

extension LoginController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginVM.loginBtnEnable
            .drive(loginBtn.rx.enableAlpha)
            .disposed(by: disposeBag)
        
        loginVM.loginBtnEnable
            .drive(loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        loginVM.response.do(onNext: { (response) in
            if response.result {
                AccountManager.instance.setUserInfo(response.data[0])
            }
        }).drive(onNext: { (response) in
            if AccountManager.instance.logined {
                SVProgressHUD.showSuccess(withStatus: response.message)
                let iNoteContentNav = getViewControllerFromMainStoryboard(withIdentifier: "iNoteContentNav")
                UIApplication.shared.keyWindow?.rootViewController = iNoteContentNav
            } else {
                SVProgressHUD.showError(withStatus: response.message)
            }
        }).disposed(by: disposeBag)
        
    }

}


