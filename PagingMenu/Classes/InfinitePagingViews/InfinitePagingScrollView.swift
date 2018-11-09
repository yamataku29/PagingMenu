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
        for _ in 1...expansionFactor {
            pagingSubviews += subviews
        }
        
        var contentWidth: CGFloat = 0
        pagingSubviews.forEach { view in
            contentWidth += view.frame.width
        }
        contentSize = CGSize(width: contentWidth, height: frame.height)
        
        pagingSubviews.enumerated().forEach { (index, view) in
            addSubview(view)
        }
        
        let centerIndex = (pagingSubviews.count/2) - 1
        scrollTo(centerIndex, animated: false)
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
