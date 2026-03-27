//
//  AppointmentChooseMode.h
//  RobotSweeper
//
//  Created by Joey on 2018/8/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentChooseMode : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstranit;

@property (weak, nonatomic) IBOutlet UILabel *modeOneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgvOne;

@property (weak, nonatomic) IBOutlet UILabel *modeTwoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgvTwo;

//1212新增模式4*4清扫
@property (weak, nonatomic) IBOutlet UIImageView *imgVFive;
@property (weak, nonatomic) IBOutlet UILabel *modelFiveLabel;



@end
