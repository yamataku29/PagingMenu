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
        setSubView()
        scrollView.contentSize = CGSize(width: scrollView.frame.width * container.count.toCGFloat,
                                        height: scrollView.frame.height)
    }
    
    func preset(with container: [UIViewController]) {
        self.container = container
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
