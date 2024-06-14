//
//  APIHelper.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 13/06/24.
//

import Foundation
import Alamofire

class APIHelper {
    class func getAPI(url: String, didSuccess: ((Any) -> Void)?, didFail: ((Error) -> Void)?) {
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                didSuccess?(value)
            case .failure(let error):
                didFail?(error)
            }
        }
    }
    
    class func getAPIWithCodable<T: Codable>(url: String, type: T.Type, didSuccess: ((T) -> Void)?, didFail: ((Error) -> Void)?) {
        AF.request(url, method: .get).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                didSuccess?(data)
            case .failure(let error):
                didFail?(error)
            }
        }
    }
    
    class func putAPI(url: String, parameters: [String: Any], didSuccess: (() -> Void)?, didError: ((Error) -> Void)?) {
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                didSuccess?()
            case .failure(let error):
                didError?(error)
            }
        }
    }
    
    class func deleteAPI(url: String, didSuccess: (() -> Void)?, didError: ((Error) -> Void)?) {
        AF.request(url, method: .delete).responseJSON { response in
            switch response.result {
            case .success:
                didSuccess?()
            case .failure(let error):
                didError?(error)
            }
        }
    }
    
    class func postAPI(url: String, parameters: [String: Any], didSuccess: (() -> Void)?, didError: ((Error) -> Void)?) {
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                didSuccess?()
            case .failure(let error):
                didError?(error)
            }
        }
    }
}
