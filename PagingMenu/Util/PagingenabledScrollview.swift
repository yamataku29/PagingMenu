//
//  PagingenabledScrollview.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/23.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingenabledScrollview: UIScrollView {
    private var currentCenterOffsetX: CGFloat {
        let screenCenterX = 0.5 * bounds.width
        return contentOffset.x + screenCenterX
    }
    
    var currentPage: Int {
        return Int(currentCenterOffsetX / bounds.width).toIndexRow
    }
}

fileprivate extension Int {
    var toIndexRow: Int {
        return self + 1
    }
}
