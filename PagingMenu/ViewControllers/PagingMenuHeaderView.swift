//
//  PagingMenuHeaderView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingMenuHeaderView: UIView {
    @IBOutlet private weak var segmentControl: PagingSegmentControlView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    func config(titles: [String]) {
        segmentControl.setSegment(titles: titles)
    }
}

private extension PagingMenuHeaderView {
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PagingMenuHeaderViewController", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
