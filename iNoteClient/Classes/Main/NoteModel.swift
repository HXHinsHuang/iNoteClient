//
//  NoteModel.swift
//  iNoteClient
//
//  Created by haoxian on 2017/10/30.
//  Copyright © 2017年 haoxian. All rights reserved.
//

import Foundation
import RxDataSources

struct ListResponse: Codable {
    let status: String
    let message: String
    let result: Bool
    var data: [NoteModel]
    
}

struct NoteModel: Codable {
    let id: String
    var title: String
    var content: String
    let createTime: String
    
    init() {
        id = "0"
        title = ""
        content = ""
        createTime = ""
    }
}

extension ListResponse: SectionModelType {
    
    var items: [NoteModel] {
        return data
    }
    
    init(original: ListResponse, items: [NoteModel]) {
        self = original
        self.data = items
    }
}
let errorListResponse = ListResponse(status: "FAILURE", message: "请求失败", result: false, data: [])
