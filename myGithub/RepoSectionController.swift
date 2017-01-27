//
//  RepoSectionController.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/28/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit
import IGListKit

class RepoSectionController: IGListSectionController {
    var repository:Repository!
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension RepoSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        return CGSize(width: context.containerSize.width, height: 50)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: RepositoryCell.self, for: self, at: index)
        if let cell = cell as? RepositoryCell {
            cell.label.text = repository.name
        }
        print(repository.name)
        return cell
    }
    
    func didUpdate(to object: Any) {
        repository = object as? Repository
    }
    
    func didSelectItem(at index: Int) {
        //
    }
}
