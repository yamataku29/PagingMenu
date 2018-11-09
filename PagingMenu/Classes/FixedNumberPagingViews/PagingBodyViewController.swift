//
//  PagingBodyViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

protocol PagingBodyViewControllerDelegate: class {
    func didEndScrolling(index: Int)
}

class PagingBodyViewController: UIViewController {
    @IBOutlet private weak var scrollView: PagingenabledScrollview!
    
    private weak var delegate: PagingBodyViewControllerDelegate?
    private var container: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubView()
        scrollView.contentSize = CGSize(width: scrollView.frame.width * container.count.toCGFloat,
                                        height: scrollView.frame.height)
        scrollView.delegate = self
    }
    
    func preset(with container: [UIViewController], delegate: PagingBodyViewControllerDelegate) {
        self.container = container
        self.delegate = delegate
    }
    
    func scrollTo(_ index: Int) {
        scrollView.scrollTo(index)
    }
}

private extension PagingBodyViewController {
    func setSubView() {
        container.enumerated().forEach { (index, viewController) in
            addChild(viewController)
            viewController.view.frame = CGRect(x: view.frame.width*index.toCGFloat, y: 0,
                                               width: viewController.view.frame.width,
                                               height: viewController.view.frame.height)
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
}

extension PagingBodyViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate, let pagingenabledScrollview = scrollView as? PagingenabledScrollview else { return }
        delegate?.didEndScrolling(index: pagingenabledScrollview.currentPageIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let pagingenabledScrollview = scrollView as? PagingenabledScrollview else { return }
        delegate?.didEndScrolling(index: pagingenabledScrollview.currentPageIndex)
    }
}
