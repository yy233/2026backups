//
//  DirectionView.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/26.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit
//已不用的方向盘
class DirectionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var forwardBtn = OBShapedButton()
    var backwardBtn = OBShapedButton()
    var rightBtn = OBShapedButton()
    var leftBtn = OBShapedButton()
    var stopBtn = OBShapedButton()
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.red

        //控制按钮
        forwardBtn.frame = CGRect(x: _originX(30),y: _originY(10) ,width: _width(100), height: _height(42))
        forwardBtn.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "Angle_Up1"), for: .normal)
        forwardBtn.addTarget(self, action: #selector(forwardMethod), for: UIControlEvents.touchUpInside)
        self.addSubview(forwardBtn)
        
        backwardBtn.frame = CGRect(x: forwardBtn.originX(), y: self.height() - _height(50), width: forwardBtn.width(),height: forwardBtn.height())
        backwardBtn.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "Angle_Down1"), for: UIControlState.normal)
        backwardBtn.addTarget(self, action: #selector(backwardMethod), for: UIControlEvents.touchUpInside)
        self.addSubview(backwardBtn)
        
        leftBtn.frame = CGRect(x: _originX(7), y: _originY(33), width: forwardBtn.height(), height:forwardBtn.width())
        leftBtn.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "Angle_Left1"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(leftMethod), for: UIControlEvents.touchUpInside)
        self.addSubview(leftBtn)
        
        rightBtn.frame = CGRect(x: self.width() - forwardBtn.height() - _width(10),y: leftBtn.originY(), width: forwardBtn.height(),height: forwardBtn.width())
        rightBtn.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "Angle_Right1"), for: UIControlState.normal)
        rightBtn.addTarget(self, action: #selector(rightMethod), for: UIControlEvents.touchUpInside)
        self.addSubview(rightBtn)
        
        
        
        stopBtn.frame = CGRect(x: 0,y: 0, width: _width(50),height:_width(50))
        stopBtn.center = CGPoint(x: leftBtn.originX() + (rightBtn.rightX() - leftBtn.originX())/2,y: forwardBtn.originY() + (backwardBtn.bottomY() - forwardBtn.originY())/2 )
        stopBtn.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "Angle_Reset1"), for: UIControlState.normal)
        stopBtn.addTarget(self, action: #selector(stopMethod), for: UIControlEvents.touchUpInside)
        self.addSubview(stopBtn)
        

    }
    
    func forwardMethod(){

        XmppManager.shareXmppManager.sendMessageToRobot(message: "order_go")
    }
    func backwardMethod(){
        
        XmppManager.shareXmppManager.sendMessageToRobot(message: "order_back")
    }
    
    func leftMethod(){
        
        XmppManager.shareXmppManager.sendMessageToRobot(message: "order_left")
        
    }
    func rightMethod(){
        
        XmppManager.shareXmppManager.sendMessageToRobot(message: "order_right")
    }
    
    func stopMethod(){
        
        XmppManager.shareXmppManager.sendMessageToRobot(message: "order_stop")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
