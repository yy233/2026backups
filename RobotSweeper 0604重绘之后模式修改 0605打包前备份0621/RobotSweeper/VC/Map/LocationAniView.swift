
//
//  LocationAniView.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/6/20.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit
//这是扫地机箭头和所在位置的动画
class LocationAniView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = SkinManager.skin_imageWithName(imageName: "guangquan")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        self.image = UIImage.init(named: "guangquan")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = DataManager.shareDataManager.colorOfMainType
        makeAnimation()
    }
    
    func makeAnimation(){
        
        var animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.repeatCount = MAXFLOAT
        animation.autoreverses = true
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
