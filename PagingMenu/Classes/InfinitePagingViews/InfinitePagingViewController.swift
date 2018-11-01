//
//  InfinitePagingViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingViewController: UIViewController {
    private var viewController1: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        return storyboard.instantiateInitialViewController()!
    }
    private var viewController2: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        return storyboard.instantiateInitialViewController()!
    }
    private var subviewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subviewControllers = [viewController1, viewController2, viewController1, viewController2]
        setSubViews()
    }
}

private extension InfinitePagingViewController {
    func setSubViews() {
        let subviews: [UIView] = subviewControllers.map { viewController in
            addChild(viewController)
            viewController.didMove(toParent: self)
            return viewController.view
        }
        let infinitePagingCollectionView = InfinitePagingCollectionView(frame: view.frame)
        infinitePagingCollectionView.center = view.center
        infinitePagingCollectionView.configure(with: subviews)
        view.addSubview(infinitePagingCollectionView)
    }
}
