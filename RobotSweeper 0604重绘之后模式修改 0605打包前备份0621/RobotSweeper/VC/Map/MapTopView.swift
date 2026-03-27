//
//  MapTopView.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/16.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class MapTopView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var areaLabel : UILabel!
    var timeLabel : UILabel!
    var chargeLabel : UILabel!

    var areaStr : NSMutableAttributedString!
    var timeStr : NSMutableAttributedString!
    var chargeStr : NSMutableAttributedString!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel1 = UILabel(frame: CGRect(x: _originX(26), y: _originY(18), width: _width(55), height: _height(50)))
        titleLabel1.font = UIFont.systemFont(ofSize: 13)
        titleLabel1.textColor = UIColor.black
        titleLabel1.numberOfLines = 0
        titleLabel1.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel1.text = NSLocalizedString("清扫\n面积", comment: "")// "清扫\n面积"
        self.addSubview(titleLabel1)
        
        let titleLabel2 = UILabel(frame: CGRect(x: _originX(166), y: _originY(18), width: _width(55), height: _height(50)))
        titleLabel2.font = titleLabel1.font
        titleLabel2.textColor = UIColor.black
        titleLabel2.numberOfLines = 0
        titleLabel2.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel2.text = NSLocalizedString("清扫\n时间", comment: "")//"清扫\n时间"
        self.addSubview(titleLabel2)
        //1225更改title的frame x: _originX(290)
        let titleLabel3 = UILabel(frame: CGRect(x: _originX(285), y: _originY(18), width: _width(55), height: _height(50))) //_width(55
        titleLabel3.font = titleLabel1.font
        titleLabel3.textColor = UIColor.black
        titleLabel3.numberOfLines = 0
        titleLabel3.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel3.text = NSLocalizedString("剩余\n电量", comment: "")//"剩余\n电量"
        self.addSubview(titleLabel3)
        //1225更改label的frame x-5 _width(200)——>90
        areaLabel = UILabel(frame: CGRect(x: titleLabel1.rightX()-5 , y: titleLabel1.originY(), width: _width(90), height: _height(50)))
        areaLabel.textColor = UIColor.black
        self.addSubview(areaLabel)
        
        timeLabel = UILabel(frame: CGRect(x: titleLabel2.rightX()-5 , y: titleLabel1.originY() , width: _width(90), height: _height(50)))
        timeLabel.textColor = UIColor.black
        self.addSubview(timeLabel)
       
        chargeLabel = UILabel(frame: CGRect(x: titleLabel3.rightX()-5 , y: titleLabel1.originY() , width: _width(90), height: _height(50)))
        chargeLabel.textColor = UIColor.black
        self.addSubview(chargeLabel)
        
 
        
        setTimeLabel(timeNum: "--")
        setAreaLabel(areaNum: "--")
        setChargeLabel(chargeNum: "--")


    }
    
    
    func setTimeLabel(timeNum:String){
        var timeNumStr:String = timeNum
//        if (timeNumStr=="0"){
//            timeNumStr = "<1"
//        }
        timeStr = NSMutableAttributedString(string: timeNumStr+"′")
        if #available(iOS 8.2, *) {
            timeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 29, weight: UIFontWeightLight)], range: NSMakeRange(0, timeStr.length - 1))
        } else {
            // Fallback on earlier versions
            timeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 29)], range: NSMakeRange(0, timeStr.length - 1))
        }
        if #available(iOS 8.2, *) {
            timeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)], range: NSMakeRange(timeStr.length - 1, 1))
        } else {
            // Fallback on earlier versions
            timeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24)], range: NSMakeRange(timeStr.length - 1, 1))
        }
        timeLabel.attributedText = timeStr
    }
    
    func setChargeLabel(chargeNum:String){
        
        chargeStr = NSMutableAttributedString(string: chargeNum+"%")
        if #available(iOS 8.2, *) {
            chargeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 29, weight: UIFontWeightLight)], range: NSMakeRange(0, chargeStr.length - 1))
        } else {
            // Fallback on earlier versions
            chargeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 29)], range: NSMakeRange(0, chargeStr.length - 1))
        }
        if #available(iOS 8.2, *) {
            chargeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)], range: NSMakeRange(chargeStr.length - 1, 1))
        } else {
            // Fallback on earlier versions
            chargeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24)], range: NSMakeRange(chargeStr.length - 1, 1))
        }
        chargeLabel.attributedText = chargeStr
    }
    func setAreaLabel(areaNum:String){
        var areaNumStr:String = areaNum
//        if (areaNum=="0"){
//            areaNumStr = "<1"
//        }
        areaStr = NSMutableAttributedString(string: areaNumStr+"㎡")
        if #available(iOS 8.2, *) {
            areaStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 29, weight: UIFontWeightLight)], range: NSMakeRange(0, areaStr.length - 1))
        } else {
            // Fallback on earlier versions
            areaStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 29)], range: NSMakeRange(0, areaStr.length - 1))
        }
        if #available(iOS 8.2, *) {
            areaStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)], range: NSMakeRange(areaStr.length - 1, 1))
        } else {
            // Fallback on earlier versions
            areaStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24)], range: NSMakeRange(areaStr.length - 1, 1))
        }
        areaLabel.attributedText = areaStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
