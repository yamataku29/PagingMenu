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
    @IBOutlet private weak var moveBarView: UIView!
    @IBOutlet private weak var barLeftLeading: NSLayoutConstraint!
    @IBOutlet private weak var barWidth: NSLayoutConstraint!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    func config(titles: [String], select index: Int = 0, moveBarColor: UIColor = .red) {
        segmentControl.setSegment(titles: titles)
        segmentControl.selectedSegmentIndex = index
        setMoveBarView(color: moveBarColor)
    }
}

private extension PagingMenuHeaderView {
    func setMoveBarView(color: UIColor) {
        moveBarView.backgroundColor = color
        barWidth.constant = segmentControl.segmentWidth
        barLeftLeading.constant = segmentControl.segmentWidth * segmentControl.selectedSegmentIndex.toCGFloat
        layoutIfNeeded()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PagingMenuHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
