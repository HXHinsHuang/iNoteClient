//
//  INoteListViewModel.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class INoteListViewModel {
    
    let command: Driver<ListEditCommand>
    
    init(input: (fetchdata: Driver<()>, delete: Driver<(NoteModel, IndexPath)>, edited: Observable<(NoteModel, IndexPath, Status)>)) {
        let refreshCommand = input.fetchdata.throttle(1.5)
            .flatMapLatest { _ in
                AppNetworkProvider.rx
                    .request(.contentList(userId: AccountManager.instance.userId ?? "0"))
                    .filterSuccessfulStatusCodes()
                    .map(ListResponse.self)
                    .map { listRes -> ListEditCommand in
                        listRes.result ? .Refresh([listRes]) : .none
                    }
                    .asDriver(onErrorJustReturn: .none)
        }
        
       let deleteCommand = input.delete.throttle(2)
            .flatMapLatest { note, ip -> Driver<(ListResponse, IndexPath)> in
                let res = AppNetworkProvider.rx
                    .request(.deleteNote(id: note.id))
                    .filterSuccessfulStatusCodes()
                    .map(ListResponse.self)
                    .asDriver(onErrorJustReturn: errorListResponse)
                let ip = Driver.just(ip)
                return Driver.combineLatest(res, ip, resultSelector: {($0,$1)})
            }.map { (res, ip) -> ListEditCommand in
                res.result ? .DeleteItem(ip) : .none
            }
        
        let editCommand = input.edited
            .filter({$0.2 != .none })
            .map { (note, ip, status) -> (AppNetwork, IndexPath, Status) in
                let userId = AccountManager.instance.userId!
                switch status {
                case .add:
                    return (.addNote(userId: userId, title: note.title, content: note.content), ip, status)
                case .modify:
                    return (.modifyNote(id: note.id, title: note.title, content: note.content), ip, status)
                case .none:
                    fatalError("不可能出现的错误!")
                }
            }.flatMapLatest{ (network, ip, status) -> Observable<(ListResponse, IndexPath, Status)> in
                let res = AppNetworkProvider.rx
                    .request(network)
                    .filterSuccessfulStatusCodes()
                    .map(ListResponse.self)
                    .asObservable()
                let ipOb = Observable.of(ip)
                let statusOb = Observable.of(status)
                return Observable.combineLatest(res, ipOb, statusOb, resultSelector: {($0,$1,$2)})
            }
            .filter({$0.2 != .none})
            .map { (res, ip, status) -> ListEditCommand in
                if res.result {
                    let note = res.data[0]
                    switch status {
                    case .add:
                        return .AppendItem(note, ip)
                    case .modify:
                        return .Update(note, ip)
                    case .none:
                        return .none
                    }
                } else {
                    return .none
                }
            }
            .asDriver(onErrorJustReturn: .none)
        
        command = Driver.of(refreshCommand ,deleteCommand, editCommand).merge()
    }
    
}

enum ListEditCommand {
    case none
    case Refresh([ListResponse])
    case AppendItem(NoteModel,IndexPath)
    case DeleteItem(IndexPath)
    case Update(NoteModel,IndexPath)
}

struct ListTableViewState {
    var sections: [ListResponse]
    
    func execute(command: ListEditCommand) -> ListTableViewState {
        var sections = self.sections
        switch command {
        case .none:
            return self
        case .Refresh(let listRes):
            return ListTableViewState(sections: listRes)
        case .AppendItem(let note, let ip):
            let notes = sections[ip.section].data + note
            sections[ip.section] = ListResponse(original: sections[ip.section], items: notes)
            return ListTableViewState(sections: sections)
        case .DeleteItem(let ip):
            var notes = sections[ip.section].data
            notes.remove(at: ip.row)
            sections[ip.section] = ListResponse(original: sections[ip.section], items: notes)
            return ListTableViewState(sections: sections)
        case .Update(let note, let ip):
            var notes = sections[ip.section].data
            notes[ip.row] = note
            sections[ip.section] = ListResponse(original: sections[ip.section], items: notes)
            return ListTableViewState(sections: sections)
        }
    }
}

func + <T>(lhs: [T], rhs: T) -> [T] {
    var copy = lhs
    copy.append(rhs)
    return copy
}









