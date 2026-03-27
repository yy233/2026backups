//
//  NetResultBean.swift
//  RobotLeo
//
//  Created by Eric on 15/5/14.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit

class NetResultBean: NSObject {
    
    
    var target:AnyObject!
    var seletor:Selector?
    var isDownloadRequest:Bool=false /**是否为下载语音请求标志*/
    
    var symbolObject:AnyObject?
   
    func requestCallBack()
    {
      if (self.target.responds(to: self.seletor!) != nil){
        
      }
    }
    
 
}
