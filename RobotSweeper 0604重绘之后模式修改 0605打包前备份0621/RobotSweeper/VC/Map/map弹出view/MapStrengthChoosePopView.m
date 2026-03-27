//
//  MapStrengthChoosePopView.m
//  RobotSweeper
//
//  Created by Joey on 2018/9/3.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MapStrengthChoosePopView.h"

@implementation MapStrengthChoosePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun"];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin"];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli"];
    
}
- (void)setImgSelectedOfStrength:(int)nowStrength{
    if (nowStrength==0) {
        [self btnActionOfBz:nil];
    }
    if (nowStrength==1) {
        [self btnActionOfJy:nil];
    }
    if (nowStrength==2) {
        [self btnActionOfQl:nil];
    }
    
}

- (IBAction)btnActionOfBz:(UIButton *)sender {
    
   
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun_an"];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin"];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli"];
   
    if (sender!=nil) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"mapStrengthChangeNotice" object:@"0"];//标准
        [self dismiss];
    }

}

- (IBAction)btnActionOfJy:(UIButton *)sender {
    
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin_an"];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun"];
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli"];
    if (sender!=nil) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mapStrengthChangeNotice" object:@"1"];//静音
        [self dismiss];
    }
}

- (IBAction)btnActionOfQl:(UIButton *)sender {
  
    _imgQl.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"qiangli_an"];
    _imgBz.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"biaozhun"];
    _imgJy.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"jingyin"];
    if (sender!=nil) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mapStrengthChangeNotice" object:@"2"];//强力
        [self dismiss];
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismiss];
}

#pragma mark - Action
-(void)showStrengthPopV {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomConstraint.constant = 0;
        self.backgroundColor = Y_RGBA(0, 0, 0, 0.3);
        [self layoutIfNeeded];
    }];
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



@end
