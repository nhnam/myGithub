//
//  RepoitoriesLoader.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/28/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit
import Moya
import IGListKit

extension NSObject: IGListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return isEqual(object)
    }
}

class Repository:NSObject {
    var name:String
    var url:String
    var createdAt:Date?
    var updatedAt:Date?
    var pushedAt:Date?
    var language:String?
    var stars:Int
    init(name:String, url:String, language:String?, stars: Int) {
        self.name = name
        self.url = url
        self.language = language
        self.stars = stars
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let repoB = object as? Repository else {
            return false
        }
        return (self.name.caseInsensitiveCompare(repoB.name) == .orderedSame)
    }
}

class RepositoriesLoader {
    var repositories:[Repository] = []
    
    func loadRepos(username aUsername:String, complete finish:@escaping (Bool) -> ()) {
        ApiProvider.request(Api.userRepositories(aUsername)) { [unowned self] (result) in
            var success = true
            switch result {
            case let .success(response):
                do {
                    let json =  try response.mapJSON()
                    if let json = json as? Array<Any>{
                        json.forEach{ (element) in
                            if let itemDict = element as? Dictionary<String, Any>{
                                let repo = Repository(name: itemDict["name"] as! String,
                                                      url: itemDict["html_url"] as! String,
                                                      language: itemDict["language"] as? String,
                                                      stars: itemDict["stargazers_count"] as! Int)
                                self.repositories.append(repo)
                            }
                        }
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                }
                break
            case let .failure(error):
                guard let errorMessage = error as? CustomDebugStringConvertible else {
                    return
                }
                print(errorMessage)
                success = false
                break
            }
            finish(success)
        }
    }
}
