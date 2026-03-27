//
//  AppointmentChooseStrength.m
//  RobotSweeper
//
//  Created by Joey on 2018/8/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AppointmentChooseStrength.h"
// 判断是否是iPhone X
#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define bottom_height (isiPhoneX ? 34.f : 10.f)
@implementation AppointmentChooseStrength

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun"];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin"];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli"];
    
}

- (IBAction)btnActionOfBz:(UIButton *)sender {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfStrengthChange" object:NSLocalizedString(@"标准",nil)];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun_an"];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin"];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli"];
   
    [self dismiss];
}

- (IBAction)btnActionOfJy:(UIButton *)sender {
  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfStrengthChange" object:NSLocalizedString(@"静音",nil)];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin_an"];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun"];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli"];
    
    [self dismiss];
}

- (IBAction)btnActionOfQl:(UIButton *)sender {
  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfStrengthChange" object:NSLocalizedString(@"强力",nil)];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli_an"];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun"];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin"];
    [self dismiss];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismiss];
}

#pragma mark - Action
-(void)show {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bottomConstraint.constant = 0;
//        self.backgroundColor = Y_RGBA(0, 0, 0, 0.4);
//        [self layoutIfNeeded];
//    }];
}
-(void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = Y_RGBA(0, 0, 0, 0);
         self.bottomConstraint.constant = -200;//用于隐藏时的下滑
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.bottomConstraint.constant = 0;
    }];
}


/**
 switch ([strong intValue]) {
 case 1:
 strOfS = @"标准";
 _strengthL.text = @"标准";
 break;
 case 2:
 strOfS = @"静音";
 _strengthL.text = @"静音";
 break;
 case 3:
 strOfS = @"强力";
 _strengthL.text = @"强力";
 break;
 
 default:
 break;
 }
 
 */
@end
