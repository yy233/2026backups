//
//  MapModeChoosePopView.h
//  RobotSweeper
//
//  Created by Joey on 2018/9/3.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapModeChoosePopView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapModeVBottomConstranit;

@property (weak, nonatomic) IBOutlet UIView *modeChoosePopBackView;//背景色

//1
@property (weak, nonatomic) IBOutlet UILabel *modeOneL;

@property (weak, nonatomic) IBOutlet UIImageView *imgVOne;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
//2
@property (weak, nonatomic) IBOutlet UILabel *modeTwoL;
@property (weak, nonatomic) IBOutlet UIImageView *imgVTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
//3
@property (weak, nonatomic) IBOutlet UILabel *modeThrL;
@property (weak, nonatomic) IBOutlet UIImageView *imgVThr;

@property (weak, nonatomic) IBOutlet UIButton *btnThr;


//4

@property (weak, nonatomic) IBOutlet UILabel *modeFouL;

@property (weak, nonatomic) IBOutlet UIImageView *imgVFou;

@property (weak, nonatomic) IBOutlet UIButton *btnFou;

//5 info
//1212 4*4 新增清扫模式 arr 4
@property (weak, nonatomic) IBOutlet UILabel *modeFiveL;
@property (weak, nonatomic) IBOutlet UIImageView *imgVFive;
@property (weak, nonatomic) IBOutlet UIButton *btnFive;


- (void)setModeAnImgBecomeSelectedImg:(int)nowModeNum;
@end
