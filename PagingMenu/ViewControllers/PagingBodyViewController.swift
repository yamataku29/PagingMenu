//
//  PagingBodyViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingBodyViewController: UIViewController {
    @IBOutlet private weak var horizontalStackView: UIStackView!
    private var container: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.forEach { viewController in
            horizontalStackView.addArrangedSubview(viewController.view)
        }
    }
    
    func configure(with container: [UIViewController]) {
        self.container = container
    }
}
