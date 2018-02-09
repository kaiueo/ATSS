//
//  NetworksHelper.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ArticleType{
    case URL
    case Text
}


var username = "aaa"
var password = "aaaaaaa"

enum Router{
    static let baseURLString = "http://127.0.0.1:5000"
    case unsummarizedArticle
    case getSummary
    case uploadSummary
    
    func asString() -> String {
        var path: String = ""
        switch self {
        case .unsummarizedArticle:
            path = "/api/v1/article/get"
        case .getSummary:
            path = "/api/v1/summary/"
        case .uploadSummary:
            path = "/api/v1/article/upload"
        }
        return Router.baseURLString + path
    }
    
    
}

struct ATSSNetworkHelper {
    
    static private func getUnsummarizedArticle(from json: JSON) -> (msg: String, article: UnsummarizedArticle?) {
        let unsummarizedArticle = UnsummarizedArticle()
        switch json["code"].int! {
        case ResponseCode.SUCCESS.rawValue:
            unsummarizedArticle.id = json["data"]["id"].string!
            unsummarizedArticle.text = json["data"]["text"].string!
            return (ResponseCode.SUCCESS.message(), unsummarizedArticle)
        case ResponseCode.FORMAT_ERROR.rawValue:
            return (ResponseCode.FORMAT_ERROR.message(), nil)
        case ResponseCode.NO_ARTICLE.rawValue:
            return (ResponseCode.NO_ARTICLE.message(), nil)
        default:
            return (ResponseCode.UNKNOEN_ERROR.message(), nil)
        }
    }
    
    static func getUnsummarizedArticle(complition: @escaping (UnsummarizedArticle?) -> Void){
        Alamofire.request(Router.unsummarizedArticle.asString()).authenticate(user: username, password: password).validate().responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let result = getUnsummarizedArticle(from: json)
                if let article = result.article {
                    complition(article)
                }else{
                    complition(nil)
                }
                
            case .failure(let error):
                print(error)
                complition(nil)
            }
        }
    
    }
    
    static private func getSummart(from json: JSON) -> (msg: String, summarization: SummarizedArticle?) {
        let summarizedArticle = SummarizedArticle()
        switch json["code"].int! {
        case ResponseCode.SUCCESS.rawValue:
            summarizedArticle.article = json["data"]["article"].string!
            summarizedArticle.summary = json["data"]["summary"].arrayObject as! [String]
            return (ResponseCode.SUCCESS.message(), summarizedArticle)
        case ResponseCode.FORMAT_ERROR.rawValue:
            return (ResponseCode.FORMAT_ERROR.message(), nil)
        case ResponseCode.NO_ARTICLE.rawValue:
            return (ResponseCode.NO_ARTICLE.message(), nil)
        default:
            return (ResponseCode.UNKNOEN_ERROR.message(), nil)
        }
        
    }
    
    static func getSummary(from articleOrUrl: ArticleOrURL, complition: @escaping (SummarizedArticle?) -> Void) {
        
        switch articleOrUrl.type {
        case .URL:
            let json: [String: Any] = [
                "type": 1,
                "count": articleOrUrl.count,
                "url": articleOrUrl.content
            ]
            Alamofire.request(Router.getSummary.asString(), method: .post, parameters: json , encoding: JSONEncoding.default, headers: nil).authenticate(user: username, password: password).validate().responseJSON {
                (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let result = getSummart(from: json)
                    if let summarization = result.summarization {
                        complition(summarization)
                    }else{
                        complition(nil)
                    }
                case .failure(let error):
                    print(error)
                    complition(nil)
                }
            }
        case .Text:
            let json: [String: Any] = [
                "type": 0,
                "count": articleOrUrl.count,
                "text": articleOrUrl.content
            ]
            Alamofire.request(Router.getSummary.asString(), method: .post, parameters: json , encoding: JSONEncoding.default, headers: nil).authenticate(user: username, password: password).validate().responseJSON {
                (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let result = getSummart(from: json)
                    if let summarization = result.summarization {
                        complition(summarization)
                    }else {
                        complition(nil)
                    }
                case .failure(let error):
                    print(error)
                    complition(nil)
                }
            }
        default:
            complition(nil)
        }
    }
    
    static func upload(summarization: SummarizationForUpload, complition: @escaping (ResponseCode) -> Void){
        let json: [String: Any] = [
            "id": summarization.id,
            "text": summarization.text,
            "summarization": summarization.summarization
        ]
        Alamofire.request(Router.uploadSummary.asString(), method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).authenticate(user: username, password: password).validate().responseJSON {
            (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                switch json["code"].int! {
                case ResponseCode.SUCCESS.rawValue:
                    complition(.SUCCESS)
                case ResponseCode.FORMAT_ERROR.rawValue:
                    complition(.FORMAT_ERROR)
                case ResponseCode.NO_ARTICLE.rawValue:
                    complition(.NO_ARTICLE)
                default:
                    complition(.UNKNOEN_ERROR)
                }
            case .failure(let error):
                print(error)
                complition(.UNKNOEN_ERROR)
            }
        }
    }
    
    
}

