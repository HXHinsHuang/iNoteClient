//
//  INoteEditController.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class INoteEditController: UIViewController {
    
    
    @IBOutlet weak var currentTitle: UINavigationItem!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTV: UITextView!
    
    var currentStatus: Status = .none
    var note: NoteModel?
    var ip: IndexPath = IndexPath(row: 0, section: 0)
    private let noteSubject = PublishSubject<(NoteModel, IndexPath, Status)>()
    var doneSubject: Observable<(NoteModel, IndexPath, Status)> {
       return noteSubject.asObserver()
    }
    lazy var editVM: INoteEditViewModel = {
        let title = titleTF.rx.text.orEmpty.asDriver()
        let content = contentTV.rx.text.orEmpty.asDriver()
        return INoteEditViewModel(input: (title, content))
    }()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.text = note?.title
        contentTV.text = note?.content
        currentStatus.rxStatus.bind(to: currentTitle.rx.statusTitle).disposed(by: bag)
        currentStatus.rxStatus.bind(to: doneBtn.rx.statusTitle).disposed(by: bag)
        editVM.doneBtnEnable.drive(doneBtn.rx.isEnabled).disposed(by: bag)
        
        doneBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            if self?.note == nil { self?.note = NoteModel() }
            self?.note?.title = (self?.titleTF.text)!
            self?.note?.content = (self?.contentTV.text)!
            self?.noteSubject.onNext(((self?.note)!, (self?.ip)!, (self?.currentStatus)!))
            self?.noteSubject.onCompleted()
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
}


extension Reactive where Base: UINavigationItem {
    var statusTitle: Binder<Status> {
        return Binder(self.base) { item, s in
            item.title = s.title
        }
    }
}

extension Reactive where Base: UIButton {
    var statusTitle: Binder<Status> {
        return Binder(self.base) { btn, s in
            btn.setTitle(s.btnText, for: .normal)
        }
    }
}
