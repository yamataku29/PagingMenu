//
//  ViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pagingMenuHeaderView: PagingMenuHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagingMenuHeaderView.configure(delegate: self, titles: ["Title1", "Title2"])
    }
}

extension ViewController: PagingMenuHeaderViewDelegate {
    func selectedSegment(index: Int) {}
}
