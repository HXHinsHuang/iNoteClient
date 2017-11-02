//
//  INoteListController.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class INoteListController: UITableViewController {

    @IBOutlet weak var addItem: UIBarButtonItem!
    @IBOutlet weak var refreshItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIButton!
    
    private let bag = DisposeBag()
    
    private lazy var listVM: INoteListViewModel = {
        let firstLoad = Driver.just(())
        let refresh = refreshItem.rx.tap.asDriver()
        let fetchData = Driver.of(firstLoad,refresh).merge()
        let delete = tableView.rx.itemDeleted.asDriver().map {[weak self] ip in
                (self?.initialState.value.sections[0].data[ip.row], ip)
            }.map { (note, ip) in
                (note!, ip)
            }
        let editResDri = editResponseSubject.asObservable().switchLatest().skip(1)
        return INoteListViewModel(input: (fetchData, delete, editResDri))
    }()
    
    private lazy var dataSource = {
        return INoteListController.rxDataSource()
    }()
    
    let initialState = Variable<ListTableViewState>(ListTableViewState(sections: []))
    let editResponseSubject = Variable(Observable.of((NoteModel(), IndexPath(row: 0, section: 0), Status.none)))
}

extension INoteListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = nil
        tableView.dataSource = nil
        
        logoutBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
                let alertController = UIAlertController(title: nil, message: "你忍心离开吗?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "点错了", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "溜了溜了...", style: .destructive, handler: { _ in
                    let iNoteLoginNav = getViewControllerFromMainStoryboard(withIdentifier: INoteController.iNoteLoginNav)
                    UIApplication.shared.keyWindow?.rootViewController = iNoteLoginNav
                    AccountManager.instance.loginOut()
                }))
                self?.present(alertController, animated: true, completion: nil)
            }).disposed(by: bag)


        addItem.rx.tap
            .subscribe(onNext: {[weak self] _ in
                let editContro = getViewControllerFromMainStoryboard(withIdentifier: INoteController.INoteEditController) as! INoteEditController
                editContro.currentStatus = .add
                self?.editResponseSubject.value = editContro.doneSubject
                self?.navigationController?.pushViewController(editContro, animated: true)
        }).disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: {[weak self] (ip) in
                let editContro = getViewControllerFromMainStoryboard(withIdentifier: INoteController.INoteEditController) as! INoteEditController
                editContro.currentStatus = .modify
                editContro.note = self?.initialState.value.sections[0].data[ip.row]
                editContro.ip = ip
                self?.editResponseSubject.value = editContro.doneSubject
                self?.navigationController?.pushViewController(editContro, animated: true)
            }).disposed(by: bag)

        listVM.command.scan(initialState) { varState, command in
            let state = varState.value.execute(command: command)
            varState.value = state
            return varState
        }
        .startWith(initialState)
        .map { varState in
            varState.value.sections
        }
        .drive(tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
    
}

extension INoteListController {
    static func rxDataSource() -> RxTableViewSectionedReloadDataSource<ListResponse> {
        return RxTableViewSectionedReloadDataSource<ListResponse>(configureCell: { ds, tv, ip, item -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: "noteContentCell", for: ip)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.createTime
            return cell
        },canEditRowAtIndexPath: { _, _ in true })
    }
}


