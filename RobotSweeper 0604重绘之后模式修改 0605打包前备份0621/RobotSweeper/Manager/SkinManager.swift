//
//  SkinManager.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/7/10.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class SkinManager: NSObject {
    
    
    
    class func skin_imageWithName(imageName:String) -> UIImage?{
        
        let resource = "colour"
        let imageStr = imageName + "_" + resource
        let image = UIImage(named: imageStr)
        
//        let twoStr :NSString  = (imageName as NSString).substring(to: 2) as NSString
//        print( (twoC,twoStr))
//        if twoStr == "z_"{
//            let image = UIImage(named: imageName)
//        }
        return image == nil ? nil : image!

    }
    class func skin_imageWithTypeAndName(imageName:String) -> UIImage?{
        
        let type = DataManager.shareDataManager.appRobotTypeStr as String
        
        let imageStr = type + "_" + imageName
        var image = UIImage(named: imageStr)
        if image == nil {
            image = UIImage(named: imageName)
        }
        return image == nil ? nil : image!
        
    }
    
    

}
