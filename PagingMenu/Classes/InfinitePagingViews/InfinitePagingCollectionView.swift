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
    
    enum PagingType {
        case normal
        case adjustable
    }
    
    private weak var infinitePagingCollectionViewDelegate: InfinitePagingCollectionViewDelegate!
    private var pagingType = PagingType.normal
    private var pagingSubviews: [UIView] = []
    private var cellItemsWidth: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    func configure(with subviews: [UIView], paging type: PagingType = .normal,
                   delegate: InfinitePagingCollectionViewDelegate) {
        guard let subview = subviews.first else { return }
        setLayout(itemSize: subview.frame.size)
        pagingType = type
        pagingSubviews = subviews
        infinitePagingCollectionViewDelegate = delegate
        setup()
    }
}

private extension InfinitePagingCollectionView {
    func setup() {
        delegate = self
        dataSource = self
        isPagingEnabled = pagingType == .normal
        decelerationRate = .fast
        register(InfinitePagingViewCell.self, forCellWithReuseIdentifier: InfinitePagingViewCell.identifier)
    }
    
    func setLayout(itemSize: CGSize) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = itemSize
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
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
        // 拡張表示するビュー数の倍率
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagingSubviews.count * expansionFactor
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row % pagingSubviews.count
        let cell = dequeueReusableCell(withReuseIdentifier: InfinitePagingViewCell.identifier,
                                       for: indexPath) as! InfinitePagingViewCell
        cell.tag = index
        cell.configure(with: pagingSubviews[index])
        return cell
    }
}

extension InfinitePagingCollectionView: UIScrollViewDelegate {
    var scrollableRange: CGFloat {
        // スクロール可能範囲は表示しているビュー数よりも小さくする必要があるので減算している
        return cellItemsWidth * (expansionFactor - 1).toCGFloat
    }
    
    func getCenterOffset(from offset: CGFloat) -> CGFloat {
        let pagingSubviewFrame = pagingSubviews.first!.frame
        let centerOffset = (frame.size.width - pagingSubviewFrame.width) / 2
        let totalOffset = offset + centerOffset
        let index = round(totalOffset / pagingSubviewFrame.width)
        return (index * pagingSubviewFrame.width) - centerOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if cellItemsWidth == 0 {
            cellItemsWidth = floor(scrollView.contentSize.width / expansionFactor.toCGFloat)
        }
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > scrollableRange) {
            scrollView.contentOffset.x = cellItemsWidth
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard pagingType == .adjustable else { return }
        let adjustedOffset = getCenterOffset(from: scrollView.contentOffset.x)
        let point = CGPoint(x: adjustedOffset, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard pagingType == .adjustable else { return }
        let adjustedOffset = getCenterOffset(from: scrollView.contentOffset.x)
        let point = CGPoint(x: adjustedOffset, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
}

class InfinitePagingViewCell: UICollectionViewCell {
    static let identifier = "InfinitePagingViewCell"
    
    func configure(with childView: UIView) {
        addSubview(childView)
    }
    
    override func prepareForReuse() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
