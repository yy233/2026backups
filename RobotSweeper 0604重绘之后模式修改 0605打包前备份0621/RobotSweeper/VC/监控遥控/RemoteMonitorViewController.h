//
//  RemoteMonitorViewController.h
//  RobotSweeper
//
//  Created by Joey on 2018/5/8.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <UIKit/UIKit.h>
//1208新增block
typedef void (^deletCodeErrArrBloc)(NSString *);

@interface RemoteMonitorViewController : UIViewController
@property (nonatomic,strong) NSString *strOfShowAreaTimeCharge;
@property (nonatomic, copy) deletCodeErrArrBloc errDeletbloc;//1208
@property (nonatomic,assign)BOOL isCanClick;//可以点击当在清扫中时则弹出框 1210

@property (nonatomic,assign)BOOL isOnlyShowMonitor;//显示单独的监控v和时间电量，其余按钮不显示
@end
