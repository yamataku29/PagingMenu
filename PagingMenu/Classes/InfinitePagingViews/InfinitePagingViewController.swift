//
//  InfinitePagingViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingViewController: UIViewController {
    
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var bodyView: InfinitePagingCollectionView!
    
    private var viewController1: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        return storyboard.instantiateInitialViewController()!
    }
    private var viewController2: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        return storyboard.instantiateInitialViewController()!
    }
    private var viewController3: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.view.backgroundColor = UIColor.red
        return viewController
    }
    private var viewController4: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.view.backgroundColor = UIColor.blue
        return viewController
    }
    private var subviewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subviewControllers = [viewController1, viewController2, viewController3, viewController4]
        setSubViews()
    }
}

private extension InfinitePagingViewController {
    func setSubViews() {
        setBodyViews()
    }
    
    func setHeaderView() {
        
    }
    
    func setBodyViews() {
        let subviews: [UIView] = subviewControllers.map { viewController in
            addChild(viewController)
            viewController.didMove(toParent: self)
            return viewController.view
        }
        bodyView.configure(with: subviews, delegate: self)
    }
}

extension InfinitePagingViewController: InfinitePagingCollectionViewDelegate {
    func didEndScrolling(index: Int) {
        print("👌Current page: \(index)")
    }
}
