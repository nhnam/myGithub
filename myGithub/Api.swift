//
//  Api.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/27/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import Foundation
import Moya
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let ApiProvider =  MoyaProvider<Api>(plugins: [NetworkLoggerPlugin(verbose:false, responseDataFormatter: JSONResponseDataFormatter)])

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum Api {
    case userProfile(String)
    case userRepositories(String)
}

extension Api: TargetType{
    var baseURL: URL { return URL(string:"https://api.github.com")! }
    var path: String {
        switch self {
        case .userProfile(let username):
            return "/users/\(username.urlEscaped)"
        case .userRepositories(let username):
            return "/users/\(username.urlEscaped)/repos"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var parameters: [String : Any]? {
        switch self {
        case .userRepositories:
            return ["sort":"pushed"]
        default:
            return nil
        }
    }
    var parameterEncoding: Moya.ParameterEncoding {
        return Alamofire.URLEncoding.default
    }
    var task: Moya.Task {
        return .request
    }
    var validate: Bool {
        return false
    }
    var sampleData: Data {
        switch self {
        case .userProfile(let name):
            return "{\"login\":\(name), \"id\": 100}".data(using: .utf8)!
        case .userRepositories(_):
            return "{\"name\":\"Nam's Repos\"}".data(using: .utf8)!
        }
    }
}

public protocol Unwrappable {
    func unwrap() -> Any?
}

extension Optional: Unwrappable {
    public func unwrap() -> Any? {
        switch self {
        case .none:
            return nil
        case .some(let unwrappable as Unwrappable):
            return unwrappable.unwrap()
        case .some (let some):
            return some
        }
    }
}

public extension String {
    init(stringInterpolationSegment expr: Unwrappable) {
        self = String(describing: expr.unwrap() ?? "")
    }
}
