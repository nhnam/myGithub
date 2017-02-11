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
import ReSwift

class ViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

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
        // subscribe to state changes
        mainStore.subscribe(self)
        
        self.title = "Nam's Github"

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        loader.loadRepos(username:"nhnam") { [weak self] _ in
            self?.adapter.reloadData { (_) in }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.dispatch( CounterActionIncrease() )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func newState(state: AppState) {
        print("App changed: \(state.counter)")
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
