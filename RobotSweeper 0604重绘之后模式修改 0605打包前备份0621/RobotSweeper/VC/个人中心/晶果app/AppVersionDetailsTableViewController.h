//
//  AppVersionDetailsTableViewController.h
//  RobotSweeper
//
//  Created by Joey on 2018/12/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppVersionDetailsTableViewController : UITableViewController
@property (nonatomic,strong)NSString *strOfVersionDetail;//版本更新信息
@property (nonatomic,strong)NSString *strOfVersionNum;//版本号
@property (nonatomic,strong)NSString *strOfVersionUpTime;//版本更新时间

@property (nonatomic,assign)int oneIsSorTwoIsC;//导航版=1 控制板=2 历史详情  0|nil为app详情 分割不同
@end
