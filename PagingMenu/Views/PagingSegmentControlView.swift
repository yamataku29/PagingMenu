//
//  PagingSegmentControlView.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class PagingSegmentControlView: UISegmentedControl {
    @IBInspectable var fontSize: CGFloat = 13
    @IBInspectable var selectedColor: UIColor = .black
    @IBInspectable var nonSelectedColor: UIColor = .gray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
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
