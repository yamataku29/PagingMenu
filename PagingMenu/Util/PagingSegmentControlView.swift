//
//  PagingSegmentControlView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingSegmentControlView: UISegmentedControl {
    @IBInspectable private var fontSize: CGFloat = 13
    @IBInspectable private var selectedColor: UIColor = .black
    @IBInspectable private var nonSelectedColor: UIColor = .gray
    
    var segmentWidth: CGFloat {
        return bounds.width / numberOfSegments.toCGFloat
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setSegment(titles: [String]) {
        removeAllSegments()
        titles.forEach { title in
            insertSegment(withTitle: title, at: numberOfSegments, animated: false)
        }
        selectedSegmentIndex = 0
    }
}

private extension PagingSegmentControlView {
    func setup() {
        layer.borderWidth = 0.0
        layer.cornerRadius = 0.0
        tintColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let nonSelectedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: nonSelectedColor
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: selectedColor
        ]
        
        setTitleTextAttributes(nonSelectedAttributes, for: UIControl.State())
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
