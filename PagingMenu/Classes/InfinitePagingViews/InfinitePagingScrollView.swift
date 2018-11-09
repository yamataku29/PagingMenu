//
//  InfinitePagingScrollView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/09.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingScrollView: PagingenabledScrollview {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private var pagingSubviews: [UIView] = []
    
    func configure(with subviews: [UIView]) {
        var contentWidth: CGFloat = 0
        pagingSubviews = subviews
        
        subviews.enumerated().forEach { (index, view) in
            view.frame.origin = CGPoint(x: view.frame.width * index.toCGFloat, y: 0)
            addSubview(view)
        }
        
        subviews.forEach { view in
            contentWidth += view.frame.width
        }
        
        contentSize = CGSize(width: contentWidth, height: frame.height)
    }
    
    func getCenterOffset(from offset: CGFloat) -> CGFloat {
        let pagingSubviewFrame = pagingSubviews.first!.frame
        let index = round(offset / pagingSubviewFrame.width)
        return index * pagingSubviewFrame.width
    }
}

private extension InfinitePagingScrollView {
    func setup() {
        delegate = self
        decelerationRate = .fast
    }
    
    var expansionFactor: Int {
        // 拡張表示するビュー数の倍率
        return 3
    }
}

extension InfinitePagingScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let adjustedOffset = getCenterOffset(from: scrollView.contentOffset.x)
        let point = CGPoint(x: adjustedOffset, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
}
