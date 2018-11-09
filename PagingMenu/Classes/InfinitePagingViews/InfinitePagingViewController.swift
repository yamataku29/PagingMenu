//
//  InfinitePagingViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingViewController: UIViewController {
    
    @IBOutlet private weak var headerView: InfinitePagingCollectionView!
    @IBOutlet private weak var bodyView: InfinitePagingCollectionView!
    
    private var subviewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subviewControllers = [viewController1, viewController2, viewController3,
                              viewController4, viewController5, viewController6]
        setHeaderView()
        setBodyView()
    }
}

private extension InfinitePagingViewController {
    func setHeaderView() {
        let texts = subviewControllers.map { $0.title! }
        let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 8)!
        let titleViewMergin: CGFloat = 30
        let titleViewWidth = getBiggestTextWidth(from: texts, font) + titleViewMergin
        let subviews: [UIView] = subviewControllers.map { viewController in
            let titleText = viewController.title!
            let titleFrame = CGRect(x: 0, y: 0, width: titleViewWidth, height: headerView.frame.height)
            let titleView = UIView(frame: titleFrame)
            let titleLabel = UILabel(frame: titleFrame)
            titleLabel.text = titleText
            titleLabel.font = font
            titleLabel.textAlignment = .center
            titleLabel.center = titleView.center
            titleView.backgroundColor = .yellow
            titleView.addSubview(titleLabel)
            return titleView
        }
        headerView.configure(with: subviews, delegate: self)
    }
    
    func setBodyView() {
        let subviews: [UIView] = subviewControllers.map { viewController in
            addChild(viewController)
            viewController.didMove(toParent: self)
            return viewController.view
        }
        bodyView.configure(with: subviews, delegate: self)
    }
    
    func getBiggestTextWidth(from texts: [String], _ font: UIFont) -> CGFloat {
        let maximumText = texts.max(by: {$1.count > $0.count})!
        return maximumText.size(withAttributes: [NSAttributedString.Key.font : font]).width
    }
}

extension InfinitePagingViewController: InfinitePagingCollectionViewDelegate {
    func didEndScrolling(index: Int) {
//        print("👌Current page: \(index)")
    }
}

/// Sample data
private extension InfinitePagingViewController {
    var viewController1: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "テスト"
        viewController.view.backgroundColor = UIColor.gray
        return viewController
    }
    
    var viewController2: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "テストテスト"
        viewController.view.backgroundColor = UIColor.red
        return viewController
    }
    
    var viewController3: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "ほげ"
        viewController.view.backgroundColor = UIColor.blue
        return viewController
    }
    
    var viewController4: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "ほげほげほげ"
        viewController.view.backgroundColor = UIColor.green
        return viewController
    }
    
    var viewController5: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "ふが"
        viewController.view.backgroundColor = UIColor.yellow
        return viewController
    }
    
    var viewController6: UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "ほげふが"
        viewController.view.backgroundColor = UIColor.white
        return viewController
    }
}
