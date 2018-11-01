//
//  FixedNumberPagingViewController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/10/18.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class FixedNumberPagingViewController: UIViewController {
    @IBOutlet weak var pagingMenuHeaderView: PagingMenuHeaderView!
    
    static let identifier = "FixedNumberPagingViewController"
    private var pagingBodyViewController: PagingBodyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagingMenuHeaderView.configure(delegate: self, titles: ["Title1", "Title2"])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pagingVC = segue.destination as? PagingBodyViewController
            else { return }
        
        pagingBodyViewController = pagingVC
        
        let storyboard1 = UIStoryboard(name: "ChildViewController1", bundle: Bundle(for: ChildViewController1.self))
        let viewController1 = storyboard1.instantiateInitialViewController()
        let storyboard2 = UIStoryboard(name: "ChildViewController2", bundle: Bundle(for: ChildViewController2.self))
        let viewController2 = storyboard2.instantiateInitialViewController()
        
        pagingBodyViewController?.preset(with: [viewController1!, viewController2!], delegate: self)
    }
}

extension FixedNumberPagingViewController: PagingMenuHeaderViewDelegate {
    func selectedSegment(index: Int) {
        pagingBodyViewController?.scrollTo(index)
    }
}

extension FixedNumberPagingViewController: PagingBodyViewControllerDelegate {
    func didEndScrolling(index: Int) {
        pagingMenuHeaderView.moveTo(index)
    }
}
