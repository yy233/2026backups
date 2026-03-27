//
//  BottomButton.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/16.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class BottomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: -10, y: contentRect.size.height + _height(10), width: contentRect.size.width+20, height: _height(15))
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
//        return CGRect(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height-_height(15))
          return CGRect(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height)
        
        
    }

}
