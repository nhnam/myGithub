//
//  FastViewController.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/28/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit

class FastViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        trigger()
    }
    
    init(_ arg: Any?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nil)
        trigger()
    }
    
    private func trigger() {
        let v = self.view
        v?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
