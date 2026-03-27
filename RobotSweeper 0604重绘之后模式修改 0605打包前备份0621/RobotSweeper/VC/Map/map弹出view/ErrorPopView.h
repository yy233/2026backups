//
//  ErrorPopView.h
//  RobotSweeper
//
//  Created by Joey on 2018/12/24.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorPopView : UIView

@property (weak, nonatomic) IBOutlet UIView *errBackView;

@property (weak, nonatomic) IBOutlet UIImageView *errImgView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLable;

@end
