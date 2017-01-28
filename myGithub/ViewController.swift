//
//  ViewController.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/27/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit
import Moya
import IGListKit

class ViewController: UIViewController {

    let loader = RepositoriesLoader()
    let collectionView: IGListCollectionView = {
       let view = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    
    lazy var adapter: IGListAdapter = {
       return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nam's Github"
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        loader.loadRepos { [weak self] in
            self?.adapter.reloadData{ (done) in }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension ViewController: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return loader.repositories
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyView()
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return RepoSectionController()
    }
}

