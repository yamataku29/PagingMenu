//
//  InfinitePagingCollectionView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

protocol InfinitePagingCollectionViewDelegate: class {
    func didEndScrolling(index: Int)
}

class InfinitePagingCollectionView: UICollectionView {
    
    var isScrollInfinity = true
    private weak var infinitePagingCollectionViewDelegate: InfinitePagingCollectionViewDelegate!
    private var pagingSubviews: [UIView] = []
    private var cellItemsWidth: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        setup()
    }
    
    func configure(with subviews: [UIView], delegate: InfinitePagingCollectionViewDelegate) {
        let layout = UICollectionViewFlowLayout()
        guard let subview = subviews.first else { return }
        layout.minimumLineSpacing = 0
        layout.itemSize = subview.frame.size
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
        pagingSubviews = subviews
        infinitePagingCollectionViewDelegate = delegate
    }
}

private extension InfinitePagingCollectionView {
    func setup() {
        delegate = self
        dataSource = self
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        register(InfinitePagingViewCell.self, forCellWithReuseIdentifier: InfinitePagingViewCell.identifier)
    }
}

extension InfinitePagingCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        infinitePagingCollectionViewDelegate?.didEndScrolling(index: cell.tag)
    }
}

extension InfinitePagingCollectionView: UICollectionViewDataSource {
    private var expansionFactor: Int {
        // 左右にスクロールされる可能性があるので実際に表示するView配列の要素を3倍にしている
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isScrollInfinity ? pagingSubviews.count * expansionFactor : pagingSubviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = isScrollInfinity ? indexPath.row % pagingSubviews.count : indexPath.row
        let cell = dequeueReusableCell(withReuseIdentifier: InfinitePagingViewCell.identifier,
                                       for: indexPath) as! InfinitePagingViewCell
        cell.tag = index
        cell.configure(with: pagingSubviews[index])
        return cell
    }
}

extension InfinitePagingCollectionView: UIScrollViewDelegate {
    var scrollableRange: CGFloat {
        // UIScrollView.contentSize.widthをリセットする閾値を実際の幅の2倍にしている
        return cellItemsWidth * 2.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isScrollInfinity else { return }
        if cellItemsWidth == 0 {
            cellItemsWidth = floor(scrollView.contentSize.width / expansionFactor.toCGFloat)
        }
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > scrollableRange) {
            scrollView.contentOffset.x = cellItemsWidth
        }
    }
}

class InfinitePagingViewCell: UICollectionViewCell {
    static let identifier = "InfinitePagingViewCell"
    
    func configure(with childView: UIView) {
        addSubview(childView)
    }
}
