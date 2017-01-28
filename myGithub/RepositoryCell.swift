//
//  RepositoryCell.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/28/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    static let topInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 15)
    static let bottomInset = UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 15)
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let linkLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.font = UIFont.italicSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(linkLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = UIEdgeInsetsInsetRect(bounds, RepositoryCell.topInset)
        linkLabel.frame = UIEdgeInsetsInsetRect(bounds, RepositoryCell.bottomInset)
    }
    
    func config(repository repositoryObject: Repository) {
        self.nameLabel.text = "\(repositoryObject.name) \(repositoryObject.stars) ⭐️"
        self.linkLabel.text = repositoryObject.url
    }
}
