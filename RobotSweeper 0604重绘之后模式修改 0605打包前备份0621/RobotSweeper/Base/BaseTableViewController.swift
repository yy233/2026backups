//
//  BaseTableViewController.swift
//  RobotLeo
//
//  Created by Eric on 15-4-28.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        #if false
            
            self.view.backgroundColor = UIColor.white
        #else
            
//            self.view.backgroundColor = UIColor.black
            
            let backImageView = UIImageView(frame: self.view.frame)
            backImageView.image = SkinManager.skin_imageWithName(imageName: "background")
            self.view.addSubview(backImageView)
            
        #endif

        
    }

    func initLeftBarItem(){
        
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 00, y: 0, width: 20, height: 20)
        leftBtn.setImage(SkinManager.skin_imageWithName(imageName: "fanhui"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarItemAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }
    func leftBarItemAction(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "navBg"), for: .default)
        
        if (self.navigationController != nil ) {
            if self.navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))
            {
                self.navigationController?.interactivePopGestureRecognizer!.delegate = nil
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
             }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func netRequestReceived(_ method:String,reqCode:String,reqDic:Dictionary<String,AnyObject>)
    {
        
    }
    func netRequestReceived(_ method: String, reqDic: Dictionary<String, AnyObject>) {
        
    }
    
    func netRequestReceived(_ method: String, reqArr: Array<AnyObject>) {
        
    }
    


    
}


