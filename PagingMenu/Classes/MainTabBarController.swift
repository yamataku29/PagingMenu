
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
        viewController.tabBarItem = UITabBarItem(title: "Fixed", image: UIImage(named: "u_turn_icon"), tag: 0)
        return viewController
    }
    
    private var infinitePagingViewController: UIViewController {
        let viewController = InfinitePagingViewController()
        viewController.tabBarItem = UITabBarItem(title: "Infinite", image: UIImage(named: "infinit_icon"), tag: 0)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([fixedNumberPagingViewController, infinitePagingViewController], animated: false)
        selectedIndex = 0
    }
}
