//
//  PagingBodyViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingBodyViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var container: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.enumerated().forEach { (index, viewController) in
            setSubView(with: viewController.view, index: index)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width * container.count.toCGFloat,
                                        height: scrollView.frame.height)
    }
    
    func configure(with container: [UIViewController]) {
        self.container = container
    }
    
    func setSubView(with view: UIView, index: Int) {
        view.bounds.origin = CGPoint(x: scrollView.frame.width * index.toCGFloat, y: 0)
        scrollView.addSubview(view)
    }
}
