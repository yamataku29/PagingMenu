//
//  ViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentControlHeaderView: PagingSegmentControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControlHeaderView.setSegment(titles: ["Title1", "Title2"])
    }
}

