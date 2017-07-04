//
//  AppDelegate.swift
//  learing
//
//  Created by Niray on 2017/6/28.
//  Copyright © 2017年 Niray. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let a = HomeVC()
        let b = NewsVC()
        let c = UserVC()
        
        let tab = UITabBarController()
        
        tab.viewControllers = [
             UINavigationController(rootViewController: a),
             UINavigationController(rootViewController: b),
             UINavigationController(rootViewController: c)]
        
        tab.tabBar.items?.enumerated().forEach{ idx, item in
            switch idx {
            case 0:
                item.title = "首页"
                item.image = UIImage.init(named: "item_a")?.withRenderingMode(.alwaysOriginal)
            case 1:
                item.title = "新闻"
                item.image = UIImage.init(named: "item_b")?.withRenderingMode(.alwaysOriginal)
            case 2:
                item.title = "我的"
                item.image = UIImage.init(named: "item_c")?.withRenderingMode(.alwaysOriginal)
            default:
                break
            }

        }
        
        tab.delegate = self
        
        window?.rootViewController = tab
        
        window?.makeKeyAndVisible()
                
        return true
    }
 
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if(tabBarController.viewControllers?.index(of: viewController) == 2){
            if let _ = UserDefaults.standard.value(forKey: "token"){
                let userVC = UserVC()
                return true
            } else {
                let loginVC = UINavigationController(rootViewController: LoginVC())
            
                loginVC.modalPresentationStyle = .popover
            
                self.window?.rootViewController?.present(loginVC, animated: true, completion: { })
                return false
            }
        }
        return true
    }
    
}

