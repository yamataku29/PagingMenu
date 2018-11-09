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
    
    func configure(with subviews: [UIView]) {
        var contentWidth: CGFloat = 0
        
        subviews.enumerated().forEach { (index, view) in
            view.frame.origin = CGPoint(x: view.frame.width * index.toCGFloat, y: 0)
            addSubview(view)
        }
        
        subviews.forEach { view in
            contentWidth += view.frame.width
        }
        
        contentSize = CGSize(width: contentWidth, height: frame.height)
    }
}

private extension InfinitePagingScrollView {
    func setup() {
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    var expansionFactor: Int {
        // 拡張表示するビュー数の倍率
        return 3
    }
}
