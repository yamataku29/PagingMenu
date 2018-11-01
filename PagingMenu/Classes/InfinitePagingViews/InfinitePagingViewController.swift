//
//  InfinitePagingViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.width
        let height = view.frame.height
        
        let infinitePagingCollectionView = InfinitePagingCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        infinitePagingCollectionView.center = CGPoint(x:width / 2,y: height / 2)
        view.addSubview(infinitePagingCollectionView)
    }
}
