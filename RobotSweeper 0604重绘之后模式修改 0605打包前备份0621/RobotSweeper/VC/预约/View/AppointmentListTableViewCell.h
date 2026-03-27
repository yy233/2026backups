//
//  TimmerListTableViewCell.h
//  RobotSweeper
//
//  Created by Joey on 2018/4/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentListTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *beginTimerTitleL;
@property (nonatomic,strong)UILabel *modelTitleL;
@property (nonatomic,strong)UILabel *strengthTitleL;
@property (nonatomic,strong)UILabel *repeatTitleL;

@property (nonatomic,strong)UILabel *beginTimerL;
@property (nonatomic,strong)UILabel *modelL;
@property (nonatomic,strong)UILabel *strengthL;
@property (nonatomic,strong)UILabel *repeatL;

@property (nonatomic,strong)UISwitch *offAndOnSwitch;

@property (nonatomic,strong)UILabel *detailL;

@property (nonatomic,strong)NSString *strOfcell;


@end
