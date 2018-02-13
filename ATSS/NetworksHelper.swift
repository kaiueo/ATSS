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




enum Router{
    static let baseURLString = "http://127.0.0.1:5000"
    case unsummarizedArticle
    case getSummary
    case uploadSummary
    case getSelfDetail
    case getToken
    
    func asString() -> String {
        var path: String = ""
        switch self {
        case .unsummarizedArticle:
            path = "/api/v1/article/get"
        case .getSummary:
            path = "/api/v1/summary/"
        case .uploadSummary:
            path = "/api/v1/article/upload"
        case .getSelfDetail:
            path = "/api/v1/auth/detail"
        case .getToken:
            path = "/api/v1/auth/token"
        }
        return Router.baseURLString + path
    }
    
    
}

struct ATSSNetworkHelper {
    
    static var username = "aaa"
    static var password = "aaaaaaa"
    
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
    
    static private func getSummary(from json: JSON) -> (code: Int, msg: String, summarization: SummarizedArticle?) {
        let summarizedArticle = SummarizedArticle()
        switch json["code"].int! {
        case ResponseCode.SUCCESS.rawValue:
            summarizedArticle.article = json["data"]["article"].string!
            summarizedArticle.summary = json["data"]["summary"].arrayObject as! [String]
            return (ResponseCode.SUCCESS.rawValue, ResponseCode.SUCCESS.message(), summarizedArticle)
        case ResponseCode.FORMAT_ERROR.rawValue:
            return (ResponseCode.FORMAT_ERROR.rawValue, ResponseCode.FORMAT_ERROR.message(), nil)
        case ResponseCode.NO_ARTICLE.rawValue:
            return (ResponseCode.NO_ARTICLE.rawValue, ResponseCode.NO_ARTICLE.message(), nil)
        case ResponseCode.NO_AMOUNT.rawValue:
            return (ResponseCode.NO_AMOUNT.rawValue, ResponseCode.NO_AMOUNT.message(), nil)
        default:
            return (ResponseCode.UNKNOEN_ERROR.rawValue, ResponseCode.UNKNOEN_ERROR.message(), nil)
        }
        
    }
    
    static func getSummary(from articleOrUrl: ArticleOrURL, complition: @escaping (SummarizedArticle?, Int) -> Void) {
        
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
                    let result = getSummary(from: json)
                    if let summarization = result.summarization {
                        complition(summarization, result.code)
                    }else{
                        complition(nil, result.code)
                    }
                case .failure(let error):
                    print(error)
                    complition(nil, ResponseCode.UNKNOEN_ERROR.rawValue)
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
                    let result = getSummary(from: json)
                    if let summarization = result.summarization {
                        complition(summarization, result.code)
                    }else {
                        complition(nil, result.code)
                    }
                case .failure(let error):
                    print(error)
                    complition(nil, ResponseCode.UNKNOEN_ERROR.rawValue)
                }
            }
        default:
            complition(nil, ResponseCode.UNKNOEN_ERROR.rawValue)
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
                case ResponseCode.NO_AMOUNT.rawValue:
                    complition(.NO_AMOUNT)
                default:
                    complition(.UNKNOEN_ERROR)
                }
            case .failure(let error):
                print(error)
                complition(.UNKNOEN_ERROR)
            }
        }
    }
    
    static private func getUser(from json: JSON) -> (msg: String, user: User?) {
        let user = User()
        switch json["code"].int! {
        case ResponseCode.SUCCESS.rawValue:
            user.username = json["data"]["username"].string!
            user.avatar = Router.baseURLString + json["data"]["avatar"].string!
            user.created_at = json["data"]["created_at"].string!
            user.uploads = json["data"]["uploads"].int!
            user.use = json["data"]["use"].int!
            user.biography = json["data"]["biography"].string!
            return (ResponseCode.SUCCESS.message(), user)
        default:
            return (ResponseCode.UNKNOEN_ERROR.message(), nil)
        }
        
    }
    
    static func getUser(complition: @escaping (User?) -> Void) {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(Router.getSelfDetail.asString()).authenticate(user: username, password: password).validate().responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                let result = getUser(from: json)
                if let user = result.user {
                    complition(user)
                }else {
                    complition(nil)
                }
            case .failure(let error):
                print(error)
                complition(nil)
            }
        }
    }
    
    static func getToken(username: String, password: String, complition: @escaping (_: String, _: String, _: Int?) -> Void) {
        Alamofire.request(Router.getToken.asString()).authenticate(user: username, password: password).response {
            (response) in
            let code = response.response?.statusCode
            complition(username, password, code)
        }
    }
    
    static func getImage(from url: String, complition: @escaping (UIImage?) -> Void) {
        Alamofire.request(url).responseData {
            (response) in
            switch response.result {
            case .success(let value):
                let image = UIImage(data: value)
                complition(image)
            case .failure(let error):
                print(error)
                complition(nil)
            }
        }
    }
    
}

