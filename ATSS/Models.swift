//
//  Models.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import Foundation

enum ResponseCode: Int {
    case SUCCESS = 0
    case FORMAT_ERROR = 1
    case UNKNOEN_ERROR = 2
    case NO_ARTICLE = 3
    
    func message() -> String{
        switch self {
        case .SUCCESS:
            return "success"
        case .FORMAT_ERROR:
            return "son format error"
        case .UNKNOEN_ERROR:
            return "unknown error"
        case .NO_ARTICLE:
            return "no unsummarized article"
        }
    }
}

class ResponseState {
    var code: ResponseCode!
    lazy var message = {
        return self.code.message()
    }()
}

class UnsummarizedArticle {
    var id: String!
    var text: String!
}

class SummarizedArticle {
    var article: String!
    var summary: [String]!
}

class SummarizationForUpload {
    var id: String!
    var text: String!
    var summarization: String!
}

class ArticleOrURL {
    var type: ArticleType!
    var count: Int!
    var content: String!
}





