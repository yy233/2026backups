//
//  RemoteControlTool.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/18.
//  Copyright © 2019 余莹. All rights reserved.
//

#import "RemoteControlTool.h"

@implementation RemoteControlTool
/**
 
 
 {
 //20190318遥控不跳转，在mapvc弹出遥控v;
 let remoteMonitorVc = RemoteMonitorTwoNoMonitorViewController()//遥控";
 if(bottomView.clearnBtn.isSelected){//1210 在清扫状态弹出框的初始值
 remoteMonitorVc.isCanClick = false
 }else{
 remoteMonitorVc.isCanClick = true
 }
 if((areaTimeCharge != "") && (areaTimeCharge != nil)){
 remoteMonitorVc.strOfShowAreaTimeCharge = areaTimeCharge! as String
 }
 //1208block回调
 remoteMonitorVc.errDeletblock = { valeOfdeletArr in ()
 self.jiankongyaokongData(valeOfdeletArr: valeOfdeletArr!)
 }
 
 self.delegatesJkYk = remoteMonitorVc as? JkYkNeedMessageAndUserStatusDelegate;
 self.navigationController?.pushViewController(remoteMonitorVc, animated: true);
 
 }
 */
+ (void)remoteControlViewShow{
    
}

+ (void)remoteControlViewHiden{
    
}
@end
