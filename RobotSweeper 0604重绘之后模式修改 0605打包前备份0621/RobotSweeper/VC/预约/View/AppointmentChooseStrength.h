//
//  AppointmentChooseStrength.h
//  RobotSweeper
//
//  Created by Joey on 2018/8/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentChooseStrength : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgBz;//标准
@property (weak, nonatomic) IBOutlet UIImageView *imgJy;//静音
@property (weak, nonatomic) IBOutlet UIImageView *imgQl;//强力
//@property (nonatomic,strong) NSString *strOfNowType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
