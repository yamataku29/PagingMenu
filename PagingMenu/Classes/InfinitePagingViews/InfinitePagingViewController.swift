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
    
    private var moveBarView: UIView!
    private var subviewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...30 {
            let vc = getDummyView(title: "ライフスタイル\(i)")
            subviewControllers.append(vc)
        }
        // setMoveBarViewを呼び出すタイミングでindex0で表示される
        // ヘッダービューのタイトルのwidthが分かれば引数として渡して上げる
        setMoveBarView()
        setHeaderView()
        setBodyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ヘッダービューコレクションビューはデフォルトで左寄せのレイアウトになるのでセンターに移動させる
        headerView.moveToCenter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            moveBarView.center = CGPoint(x: headerView.center.x, y: headerView.frame.maxY - moveBarView.frame.height/2)
            moveBarView.layoutIfNeeded()
        }
    }
}

private extension InfinitePagingViewController {
    func setMoveBarView() {
        moveBarView = UIView()
        moveBarView.frame.size = CGSize(width: 100, height: 2)
        moveBarView.center = CGPoint(x: headerView.center.x, y: headerView.frame.maxY - moveBarView.frame.height/2)
        moveBarView.backgroundColor = .blue
        view.addSubview(moveBarView)
    }
    
    func setHeaderView() {
        let texts = subviewControllers.map { $0.title! }
        let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 10)!
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
            titleView.addSubview(titleLabel)
            return titleView
        }
        headerView.configure(with: subviews, paging: .adjustable, delegate: self)
    }
    
    func setBodyView() {
        let subviews: [UIView] = subviewControllers.map { viewController in
            let label = UILabel(frame: CGRect(x: viewController.view.center.x-100, y: 350,
                                              width: 200, height: 50))
            label.text = viewController.title
            label.textAlignment = .center
            viewController.view.addSubview(label)
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
    
    func resizeMoveBarView(with width: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.moveBarView.frame.size = CGSize(width: width, height: self.moveBarView.frame.height)
            self.moveBarView.center = CGPoint(x: self.view.center.x, y: self.moveBarView.center.y)
        })
    }
}

extension InfinitePagingViewController: InfinitePagingCollectionViewDelegate {
    func didEndScrolling(collectionView: UICollectionView, index: Int, isSwipeToRight: Bool, isTappedCell: Bool) {
        let width = CGFloat.random(in: 20...180)
        resizeMoveBarView(with: width)
        if collectionView == headerView { bodyView.moveTo(index, isSwipeToRight: isSwipeToRight) }
        if collectionView == bodyView || isTappedCell { headerView.moveTo(index, isSwipeToRight: isSwipeToRight) }
    }
}

/// Sample data
private extension InfinitePagingViewController {
    func getDummyView(title: String = "テスト", color: UIColor = .red) -> UIViewController {
        let storyboard = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = title
        viewController.view.backgroundColor = color
        return viewController
    }
}
