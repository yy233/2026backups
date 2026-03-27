//
//  AppointmentChooseMode.m
//  RobotSweeper
//
//  Created by Joey on 2018/8/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AppointmentChooseMode.h"

@implementation AppointmentChooseMode

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    _modeOneLabel.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
    _modeTwoLabel.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[1]];
    _imgvOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zidongdasao"];
    _imgvTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"bianjiaodasao"];
    //1212新增协议
    _modelFiveLabel.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[2]];
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"yuyueMode_44"];
    
}

- (IBAction)btnOneAction:(UIButton *)sender {//
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfModeChange" object:@"1"];
   _imgvOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zidongdasao_an"];
    _imgvTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"bianjiaodasao"];
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"yuyueMode_44"];
    
    [self dismiss];
}

- (IBAction)btnTwoAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfModeChange" object:@"2"];
    _imgvTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"bianjiaodasao_an"];
    _imgvOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zidongdasao"];
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"yuyueMode_44"];
    [self dismiss];
}

//4*4清扫 1212新增
- (IBAction)BtnfiveAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfModeChange" object:@"5"];
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"yuyueMode_44_an"];
    _imgvOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zidongdasao"];
    _imgvTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"bianjiaodasao"];
    [self dismiss];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

-(void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = Y_RGBA(0, 0, 0, 0);
        self.bottomConstranit.constant = -200;//用于隐藏时的下滑
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.bottomConstranit.constant = 0;
    }];
}
@end
