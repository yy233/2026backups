//
//  BaseCollectionViewController.swift
//  RobotLeo
//
//  Created by Eric on 15/5/20.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit


class BaseCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImageView(frame: self.view.frame)
//        backImage.image = UIImage(named: "remote_bg")
        self.view.addSubview(backImage)
        
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        backBtn.setImage(SkinManager.skin_imageWithName(imageName: "fanhui"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(BaseCollectionViewController.goBackPage), for: UIControlEvents.touchUpInside)
        
         self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: SkinManager.skin_imageWithName(imageName: "fanhui"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseCollectionViewController.goBackPage))
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: NSNotification.Name(rawValue: "robotReset"), object: nil)
        
        
        if (self.navigationController != nil ) {
            if self.navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)){
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
    func reset ()  {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    func netRequestReceived(_ method: String, reqCode: String, reqDic: Dictionary<String, AnyObject>) {
        
    }
    func netRequestReceived(_ method: String, reqDic: Dictionary<String, AnyObject>) {
        
    }
    func netRequestReceived(_ method: String, reqArr: Array<AnyObject>) {
        
    }


    
    func goBackPage(){
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
}
