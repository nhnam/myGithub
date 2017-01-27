//
//  ViewController.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/27/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ApiProvider.request(Api.userRepositories("nhnam")) { (result) in
            switch result {
            case let .success(response):
                do {
                    let json =  try response.mapJSON() as? Array<Any>
                    print(json?.count)
                } catch {
                    
                }
                break
            case let .failure(error):
                guard let errorMessage = error as? CustomDebugStringConvertible else {
                    return
                }
                print(errorMessage)
                break
            }
        }
    }

}

