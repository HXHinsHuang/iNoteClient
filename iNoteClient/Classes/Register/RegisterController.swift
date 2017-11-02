//
//  RegisterController.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/22.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterController: UIViewController {
    
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton! {
        didSet {
            registerBtn.layer.cornerRadius = 8
            registerBtn.layer.masksToBounds = true
        }
    }
    
    private lazy var registerVM: RegisterViewModel = {
        let pnDri = phoneNumTF.rx.text.orEmpty.asDriver()
        let pwdDri = passwordTF.rx.text.orEmpty.asDriver()
        let resBtnDri = registerBtn.rx.tap.asDriver()
        return RegisterViewModel(input: (pnDri, pwdDri, resBtnDri))
    }()
    private let disposeBag = DisposeBag()
    
}

extension RegisterController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerVM.registerBtnEnable.drive(registerBtn.rx.enableAlpha).disposed(by: disposeBag)
        registerVM.registerBtnEnable.drive(registerBtn.rx.isEnabled).disposed(by: disposeBag)
        
        registerVM.response.drive(onNext: {[weak self] (response) in
            let alertC = UIAlertController(title: response.status, message: response.message, preferredStyle: .alert)
            alertC.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] _ in
                if response.result {
                    self?.navigationController?.popViewController(animated: true)
                }
            }))
            self?.present(alertC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }

}

