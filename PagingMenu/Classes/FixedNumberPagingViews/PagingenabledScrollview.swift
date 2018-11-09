//
//  PagingenabledScrollview.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/23.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingenabledScrollview: UIScrollView {
    var currentPage: Int {
        return Int(currentCenterOffsetX / bounds.width).toIndexRow
    }
    
    var currentPageIndex: Int {
        return Int(currentCenterOffsetX / bounds.width)
    }
    
    func getPagePosition(from index: Int) -> CGPoint {
        let offsetX = index.toCGFloat * frame.width
        return CGPoint(x: offsetX, y: 0)
    }
    
    func scrollTo(_ index: Int, animated: Bool = true) {
        let offset = getPagePosition(from: index)
        setContentOffset(offset, animated: animated)
    }
}

private extension PagingenabledScrollview {
    var screenCenterX: CGFloat {
        return bounds.width / 2
    }
    
    var currentCenterOffsetX: CGFloat {
        return contentOffset.x + screenCenterX
    }
}

fileprivate extension Int {
    var toIndexRow: Int {
        return self + 1
    }
}
