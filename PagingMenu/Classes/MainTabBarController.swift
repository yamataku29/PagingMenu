
//
//  MainTabBarController.swift
//  PagingMenu
//
//  Created by 山田卓 on 2018/11/01.
//  Copyright © 2018 TakuYamada. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    private var fixedNumberPagingViewController: UIViewController {
        let storyboard = UIStoryboard(name: FixedNumberPagingViewController.identifier, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.tabBarItem = UITabBarItem(title: "Fixed", image: UIImage(named: "fixed_icon"), tag: 0)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([fixedNumberPagingViewController], animated: false)
        selectedIndex = 0
    }
}
