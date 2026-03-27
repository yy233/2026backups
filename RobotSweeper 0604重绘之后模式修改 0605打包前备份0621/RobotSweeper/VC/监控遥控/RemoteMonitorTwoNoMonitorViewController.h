//
//  RemoteMonitorTwoHaveMonitorViewController.h
//  RobotSweeper
//
//  Created by Joey on 2018/7/17.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>
//1208新增block 
typedef void (^deletCodeErrArrBlock)(NSString *);

@interface RemoteMonitorTwoNoMonitorViewController : UIViewController
@property (nonatomic,strong) NSString *strOfShowAreaTimeCharge;
@property (nonatomic, copy) deletCodeErrArrBlock errDeletblock;//1208 code清除 0111新增自动清扫+回充的数据刷新UI回调，其中的文本数据不同来区分。
@property (nonatomic,assign)BOOL isCanClick;//可以点击当在清扫中时则弹出框 1210
@end
