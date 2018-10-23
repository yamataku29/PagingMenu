//
//  PagingMenuHeaderView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

protocol PagingMenuHeaderViewDelegate: class {
    func selectedSegment(index: Int)
}

class PagingMenuHeaderView: UIView {
    @IBOutlet private weak var segmentControl: PagingSegmentControlView!
    @IBOutlet private weak var moveBarView: UIView!
    @IBOutlet private weak var barLeftLeading: NSLayoutConstraint!
    @IBOutlet private weak var barWidth: NSLayoutConstraint!
    
    @IBAction func tapSegment(_ sender: UISegmentedControl) {
        delegate?.selectedSegment(index: sender.selectedSegmentIndex)
        movingBarView()
    }
    
    private weak var delegate: PagingMenuHeaderViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    func configure(delegate: PagingMenuHeaderViewDelegate, titles: [String],
                   select index: Int = 0, moveBarColor: UIColor = .red) {
        self.delegate = delegate
        segmentControl.setSegment(titles: titles)
        segmentControl.selectedSegmentIndex = index
        setMoveBarView(color: moveBarColor)
    }
}

private extension PagingMenuHeaderView {
    func movingBarView() {
        barLeftLeading.constant = segmentControl.segmentWidth * segmentControl.selectedSegmentIndex.toCGFloat
        UIView.animate(withDuration: 0.15, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func setMoveBarView(color: UIColor) {
        moveBarView.backgroundColor = color
        barWidth.constant = segmentControl.segmentWidth
        movingBarView()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PagingMenuHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
