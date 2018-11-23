//
//  InfinitePagingCollectionView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

protocol InfinitePagingCollectionViewDelegate: class {
    func didEndScrolling(collectionView: UICollectionView, index: Int, isSwipeToRight: Bool)
}

class InfinitePagingCollectionView: UICollectionView {
    
    enum PagingType {
        case normal
        case adjustable
    }
    
    private weak var infinitePagingCollectionViewDelegate: InfinitePagingCollectionViewDelegate!
    private var pagingType = PagingType.normal
    private(set) var pagingSubviews: [UIView] = []
    private var cellItemsWidth: CGFloat {
        return floor(contentSize.width / expansionFactor.toCGFloat)
    }
    
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
        // 初期表示時にはスクロール系のDelegateメソッドが発火しないので
        // ここでindex0のぺセルが表示されていることをdelegateに伝える
        infinitePagingCollectionViewDelegate?.didEndScrolling(collectionView: self, index: 0, isSwipeToRight: false)
    }
    
    func moveToCenter() {
        guard let firstSubview = pagingSubviews.first else { return }
        let totalOffsetX = firstSubview.frame.width * (pagingSubviews.count).toCGFloat - inScreenOffsetX
        contentOffset.x = totalOffsetX
    }
    
    func moveTo(_ index: Int, isSwipeToRight: Bool) {
        guard let firstSubview = pagingSubviews.first else { return }
        let currentIndex = getCurrentPageIndex(from: contentOffset.x)
        print("🚀currentIndex: \(currentIndex)")
        print("🚀moveToIndex: \(index)")
        print("🚀pagingSubviews.count: \(pagingSubviews.count)")
        print("🚀isSwipeToRight: \(isSwipeToRight)")
//        let diffIndex = abs(index - currentIndex)
        let diffIndex = isSwipeToRight ? getDecrementIndex(by: index) : getIncrementIndex(by: index)
        let exceedCount = floor(Double(diffIndex / pagingSubviews.count.toIndex))
        let index = (diffIndex%pagingSubviews.count.toIndex) + Int(exceedCount)
        let moveToOffset = firstSubview.frame.width * (isSwipeToRight ? -index : index).toCGFloat
        let totalOffsetX = moveToOffset + contentOffset.x - inScreenOffsetX
//        let moveToOffsetX = firstSubview.frame.width * index.toCGFloat - inScreenOffsetX
        print("🚀(diffIndex%pagingSubviews.count): \((diffIndex%pagingSubviews.count))")
        print("🚀exceedCount: \(exceedCount)")
        print("🚀firstSubview.frame.width: \(firstSubview.frame.width)")
        print("🚀diffIndex: \(diffIndex)")
        print("🚀index: \(index)")
        print("🚀contentOffset.x: \(contentOffset.x)")
        print("🚀moveToOffset: \(moveToOffset)")
        print("🚀totalOffsetX: \(totalOffsetX)")
        setContentOffset(CGPoint(x: totalOffsetX, y: 0), animated: true)
    }
}

private extension InfinitePagingCollectionView {
    var inScreenOffsetX: CGFloat {
        guard let firstSubview = pagingSubviews.first else { return 0 }
        return (frame.width - firstSubview.frame.width) / 2
    }
    
    func setup() {
        delegate = self
        dataSource = self
        isPagingEnabled = pagingType == .normal
        decelerationRate = .fast
        register(InfinitePagingViewCell.self, forCellWithReuseIdentifier: InfinitePagingViewCell.identifier)
        guard let firstSubview = pagingSubviews.first else { return }
        let size = CGSize(width: firstSubview.frame.width * pagingSubviews.count.toCGFloat, height: firstSubview.frame.height)
        contentSize = size
    }
    
    func setLayout(itemSize: CGSize) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = itemSize
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
    }
    
    func getIncrementIndex(by newIndex: Int) -> Int {
        let currentIndex = getCurrentPageIndex(from: contentOffset.x)
        // indexが増える前提で呼び出されるメソッドのためnewIndexが
        // currentIndex以下になった場合は閾値を超えたとみなす
        if currentIndex > newIndex {
            return (pagingSubviews.count - currentIndex) + newIndex
        } else {
            return newIndex - currentIndex
        }
    }
    
    func getDecrementIndex(by newIndex: Int) -> Int {
        let currentIndex = getCurrentPageIndex(from: contentOffset.x)
        // indexが減る前提で呼び出されるメソッドのためnewIndexが
        // currentIndex以下になった場合は閾値を超えたとみなす
        if currentIndex < newIndex {
            return (pagingSubviews.count - newIndex) + currentIndex
        } else {
            return currentIndex - newIndex
        }
    }
}

extension InfinitePagingCollectionView: UICollectionViewDelegate {}

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
        guard let firstSubview = pagingSubviews.first else { return 0 }
        let totalOffset = offset + inScreenOffsetX
        let index = round(totalOffset / firstSubview.frame.width)
        return (index * firstSubview.frame.width) - inScreenOffsetX
    }
    
    func getCurrentPageIndex(from offset: CGFloat) -> Int {
        guard let firstSubview = pagingSubviews.first else { return 0 }
        let totalOffset = offset + inScreenOffsetX
        let index = Int(round(totalOffset / firstSubview.frame.width)) % pagingSubviews.count
        return index
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > scrollableRange) {
            scrollView.contentOffset.x = cellItemsWidth
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPageIndex = getCurrentPageIndex(from: scrollView.contentOffset.x)
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        let isScrollToRight = translation.x > 0
        infinitePagingCollectionViewDelegate?.didEndScrolling(collectionView: self, index: currentPageIndex,
                                                              isSwipeToRight: isScrollToRight)
        
        guard pagingType == .adjustable else { return }
        let adjustedOffset = getCenterOffset(from: scrollView.contentOffset.x)
        let point = CGPoint(x: adjustedOffset, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let currentPageIndex = getCurrentPageIndex(from: scrollView.contentOffset.x)
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            let isScrollToRight = translation.x > 0
            infinitePagingCollectionViewDelegate?.didEndScrolling(collectionView: self, index: currentPageIndex,
                                                                  isSwipeToRight: isScrollToRight)
        }
        
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
