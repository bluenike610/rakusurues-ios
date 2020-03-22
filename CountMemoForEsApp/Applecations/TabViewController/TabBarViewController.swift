//
//  TabBarViewController.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController , UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;

        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        UITabBar.appearance().barTintColor = UIColor.darkGray

        var bottomSafeHeight : CGFloat = 0.0

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomSafeHeight = (window?.safeAreaInsets.bottom)!
        }
        let item1 = self.tabBar.items![0] as UITabBarItem;
        let item2 = self.tabBar.items![1] as UITabBarItem;
        let item3 = self.tabBar.items![2] as UITabBarItem;
        let item4 = self.tabBar.items![3] as UITabBarItem;
        
        self.tabBar.tintColor = .white
        
        var topInset = 10
        var bottomInset = 10
        var verticalOffset = -5
        if bottomSafeHeight > 0 {
            topInset = 20
            bottomInset = 0
            verticalOffset = 20
        }

        item1.image = UIImage(named: "navbar-edit@2x.png")?.withRenderingMode(.alwaysOriginal);
        item1.imageInsets = UIEdgeInsets(top: CGFloat(3), left: 0, bottom: CGFloat(3), right: 0);
        item2.image = UIImage(named: "ic_todo")?.withRenderingMode(.alwaysOriginal);
        item2.imageInsets = UIEdgeInsets(top: CGFloat(topInset+10), left: 0, bottom: CGFloat(bottomInset+10), right: 0);
        item3.image = UIImage(named: "ic_calendar")?.withRenderingMode(.alwaysOriginal);
        item3.imageInsets = UIEdgeInsets(top: CGFloat(topInset+18), left: 0, bottom: CGFloat(bottomInset+18), right: 0);
        item4.image = UIImage(named: "ic_account")?.withRenderingMode(.alwaysOriginal);
        item4.imageInsets = UIEdgeInsets(top: CGFloat(topInset+3), left: 0, bottom: CGFloat(bottomInset+3), right: 0);

        item1.title = "ES Memo";
        item1.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item2.title = "TODO";
        item2.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item3.title = "Calendar";
        item3.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item4.title = "Account";
        item4.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));

//        item1.selectedImage = UIImage(named: "setting@2x.png")?.withRenderingMode(.alwaysOriginal);
//        item2.selectedImage = UIImage(named: "setting@2x.png")?.withRenderingMode(.alwaysOriginal);
//        item3.selectedImage = UIImage(named: "setting@2x.png")?.withRenderingMode(.alwaysOriginal);
//        item4.selectedImage = UIImage(named: "setting@2x.png")?.withRenderingMode(.alwaysOriginal);

        setNeedsStatusBarAppearanceUpdate();
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabitem = tabBarController.selectedIndex;
        let currentNavView :UINavigationController = tabBarController.selectedViewController as! UINavigationController
        currentNavView.popToRootViewController(animated: true)
    }
    
}
