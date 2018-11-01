//
//  InfinitePagingCollectionView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class InfinitePagingCollectionView: UICollectionView {
    
    let colors: [UIColor] = [.blue, .yellow, .red, .green, .gray]
    let isInfinity = true
    var cellItemsWidth: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(InfinitePagingViewCell.self, forCellWithReuseIdentifier: InfinitePagingViewCell.identifier)
    }
    
    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: frame.height / 2)
        layout.scrollDirection = .horizontal
        
        self.init(frame: frame, collectionViewLayout: layout)
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
    }
    
}

private extension InfinitePagingCollectionView {}

extension InfinitePagingCollectionView: UICollectionViewDelegate {
    func configure(cell: InfinitePagingViewCell, indexPath: IndexPath) {
        // indexを修正する
        let fixedIndex = isInfinity ? indexPath.row % colors.count : indexPath.row
        cell.contentView.backgroundColor = colors[fixedIndex]
    }
}

extension InfinitePagingCollectionView: UICollectionViewDataSource {
    // セクションごとのセル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInfinity ? colors.count * 3 : colors.count
    }
    
    // セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: InfinitePagingViewCell.identifier, for: indexPath) as! InfinitePagingViewCell
        
        configure(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

extension InfinitePagingCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isInfinity {
            if cellItemsWidth == 0.0 {
                cellItemsWidth = floor(scrollView.contentSize.width / 3.0) // 表示したい要素群のwidthを計算
            }
            if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > cellItemsWidth * 2.0) { // スクロールした位置がしきい値を超えたら中央に戻す
                scrollView.contentOffset.x = cellItemsWidth
            }
        }
    }
}

class InfinitePagingViewCell: UICollectionViewCell {
    static let identifier = "InfinitePagingViewCell"
}
