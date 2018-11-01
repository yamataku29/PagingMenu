//
//  InfinitePagingCollectionView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingCollectionView: UICollectionView {
    
    private let colors: [UIColor] = [.blue, .yellow, .red, .green, .gray]
    private var cellItemsWidth: CGFloat = 0
    
    var isScrollInfinity = true
    private var pagingSubviews: [UIView] = []
    
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
    
    func configure(with subviews: [UIView]) {
        let layout = UICollectionViewFlowLayout()
        guard let subview = subviews.first else { return }
        layout.itemSize = subview.frame.size
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
        pagingSubviews = subviews
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
    func configure(cell: InfinitePagingViewCell, indexPath: IndexPath) {
        let fixedIndex = isScrollInfinity ? indexPath.row % colors.count : indexPath.row
        cell.contentView.backgroundColor = colors[fixedIndex]
    }
}

extension InfinitePagingCollectionView: UICollectionViewDelegate {
    // 不要な場合は削除する
}

extension InfinitePagingCollectionView: UICollectionViewDataSource {
    var expansionFactor: Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isScrollInfinity ? pagingSubviews.count * expansionFactor : pagingSubviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = isScrollInfinity ? indexPath.row % pagingSubviews.count : indexPath.row
        let cell = dequeueReusableCell(withReuseIdentifier: InfinitePagingViewCell.identifier,
                                       for: indexPath) as! InfinitePagingViewCell
        cell.configure(with: pagingSubviews[index])
        return cell
    }
}

extension InfinitePagingCollectionView: UIScrollViewDelegate {
    var scrollableRange: CGFloat {
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
