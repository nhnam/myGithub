//
//  TestHelper.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/30/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

public func loadSampleUserRepositories() -> JSON {
    do {
        let bundle = Bundle(for: ApiSpec.self)
        let path = bundle.path(forResource: "userRepositories_Sample", ofType: "json")!
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath:path))
        let json = JSON(data: jsonData, options: .allowFragments, error: nil)
        return json
    } catch {
        return JSON(parseJSON: "[]")
    }
}
