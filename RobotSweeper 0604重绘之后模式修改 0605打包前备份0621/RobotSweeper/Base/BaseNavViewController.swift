//
//  BaseNavViewController.swift
//  RobotLeo
//
//  Created by Eric on 15-4-22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController,UINavigationControllerDelegate{

    
    var hideBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationBar.tintColor=UIColor.white
        /*如果你使用了系统的UINavigationController，且它的navigationBar没有被隐藏的话，它的rootController及之后push的controller的preferredStatusBarStyle方法不会被调用（其他两个方法还是会被调用）； UINavigationController会根据自己navigationBar的barStyle，来决定StatusBarStyle的值； 如果你设置了self.navigationController.navigationBarHidden = YES； 那preferredStatusBarStyle就会被正常调用了*/
        
//        self.navigationBar.barStyle=UIBarStyle.black //设置barStyle后状态栏会自动确定颜色
//        self.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
       self.delegate = self
        
        

    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    
        
//        for view:UIView in (self.navigationBar.subviews ){
//
//            if NSClassFromString("_UINavigationBarBackground") != nil{
//                if view.isKind(of: NSClassFromString("_UINavigationBarBackground")!)
//                {
//
//                    view.alpha = 0.4
//                    
//                }
//            }else if NSClassFromString("_UIBarBackground") != nil{
//                if view.isKind(of: NSClassFromString("_UIBarBackground")!)
//                {
//                    
//                    view.alpha = 0.4
//
//                    
//                }
//            }
//            
//        }
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
       
    }


}
