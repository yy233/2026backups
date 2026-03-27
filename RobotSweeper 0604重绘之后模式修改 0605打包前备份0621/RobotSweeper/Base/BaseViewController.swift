//
//  BaseViewController.swift
//  RobotLeo
//
//  Created by Eric on 15-4-22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate  {
    
//    var modelEngineVoip=ModelEngineVoip.getInstance()//云通信sdk实例
    
    var tapGestureRc : UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        #if false
        
            self.view.backgroundColor = UIColor.white
            
        #else
        
            self.view.backgroundColor = UIColor.black
            //背景图
//            let backImageView = UIImageView(frame: self.view.frame)
//            backImageView.image = SkinManager.skin_imageWithName(imageName: "background")
//            self.view.addSubview(backImageView)
            
        #endif
        
        //添加tap手势
        tapGestureRc=UITapGestureRecognizer(target: self, action: #selector(BaseViewController.clickview))
        tapGestureRc.delegate = self
        
        self.view.addGestureRecognizer(tapGestureRc)
        
        
    }
    
    
    func initLeftBarItem(){
        
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 00, y: 0, width: 20, height: 20)
//        leftBtn.setImage(SkinManager.skin_imageWithName(imageName: "fanhui"), for: .normal)
         leftBtn.setImage(UIImage(named: "返回按钮"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(leftBarItemAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }
    func leftBarItemAction(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "navBg"), for: .default)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if (self.navigationController != nil ) {
            if self.navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)){
                self.navigationController?.interactivePopGestureRecognizer!.delegate = nil
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self) //1210修改
        
    }
    
//    ///1210修改  0122隐藏掉 不删
//    deinit {
//         NotificationCenter.default.removeObserver(self)
//    }
//
    func goBackPage(){
        
//        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.popViewController(animated: true)
    }


    //点击空白区域隐藏键盘
    func clickview(){
        ResignFirstResponder()
    }
   
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        
        return true
    }
    
    func removeGes(){
        self.view.removeGestureRecognizer(tapGestureRc)
    }
    
    //网络回调
    func netRequestReceived(_ method:String,reqCode:String,reqDic:Dictionary<String,AnyObject>)
    {
        
    }
    func netRequestReceived(_ method: String, reqDic: Dictionary<String, AnyObject>)
    {
        
    }
    func netRequestReceived(_ method: String, reqArr: Array<AnyObject>) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
