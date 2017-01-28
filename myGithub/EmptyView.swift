//
//  EmptyView.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/28/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let label = UILabel()
        label.textAlignment = .center
        label.text = "👷🏻👷🏻‍♀️"
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(label)
    }
    
}
