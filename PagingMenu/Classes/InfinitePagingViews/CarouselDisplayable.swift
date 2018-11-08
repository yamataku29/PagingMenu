//
//  CarouselDisplayable.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/08.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

protocol CarouselDisplayable {
    var collectionView: UICollectionView! { get set }
    var collectionViewFrontPage: Int { get }
}

extension CarouselDisplayable {
    var collectionViewFrontPage: Int {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        let pageWidth = pageSize.width
        let offset = collectionView.contentOffset.x
        return Int(floor((offset - pageWidth / 2) / pageWidth) + 1)
    }
}
