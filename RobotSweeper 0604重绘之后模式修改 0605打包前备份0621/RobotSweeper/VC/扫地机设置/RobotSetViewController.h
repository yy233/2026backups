//
//  RobotSetViewController.h
//  RobotSweeper
//
//  Created by Joey on 2018/5/8.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotSetViewController : UIViewController

@property (nonatomic,assign) BOOL isCanUpOfSoftware;
@property (nonatomic,assign) BOOL isCanUpOfhardware;

@property (nonatomic,strong) NSString *areaTimeChargeStr;
@end
