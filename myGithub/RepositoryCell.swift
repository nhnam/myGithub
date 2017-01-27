//
//  RepositoryCell.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/28/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    static let inset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = UIEdgeInsetsInsetRect(bounds, RepositoryCell.inset)
    }
}
