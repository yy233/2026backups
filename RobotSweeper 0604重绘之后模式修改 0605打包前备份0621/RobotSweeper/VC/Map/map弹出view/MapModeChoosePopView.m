//
//  MapModeChoosePopView.m
//  RobotSweeper
//
//  Created by Joey on 2018/9/3.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MapModeChoosePopView.h"

@implementation MapModeChoosePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    //label
    _modeOneL.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].mapModeArrMain.firstObject];
    _modeTwoL.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].mapModeArrMain[1]];
    _modeThrL.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].mapModeArrMain[2]];
    _modeFouL.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].mapModeArrMain[3]];
    
    //img
    _imgVOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_zidongdasao"];
    _imgVTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_dingdiandasao"];
    _imgVThr.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_quyudasao"];
    _imgVFou.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_bianjiaodasao"];
    
    //新增4*4
      _modeFiveL.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].mapModeArrMain[4]];
     _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_44"];
}

- (void)setModeAnImgBecomeSelectedImg:(int)nowModeNum{
    switch (nowModeNum) {
        case 0:
            [self btnOneAction:nil];
            break;
        case 1:
             [self btnTwoAction:nil];
            break;
        case 2:
            [self btnThrAction:nil];
            break;
        case 3:
            [self btnFouAction:nil];
            break;
        case 4:
            [self btnFiveAction:nil];
            break;
            
        default:
            break;
    }
}
- (IBAction)btnOneAction:(UIButton *)sender {
   
    _imgVOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_zidongdasao_an"];
    _imgVTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_dingdiandasao"];
    _imgVThr.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_quyudasao"];
    _imgVFou.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_bianjiaodasao"];
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_44"];
    if (sender!=nil) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"mapModeChangeNotice" object:@"0"];
        [self dismiss];
    }
  
}

- (IBAction)btnTwoAction:(UIButton *)sender {

    _imgVOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_zidongdasao"];
    _imgVTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_dingdiandasao_an"];
    _imgVThr.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_quyudasao"];
    _imgVFou.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_bianjiaodasao"];
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_44"];
    if (sender!=nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mapModeChangeNotice" object:@"1"];
        [self dismiss];
    }
}
- (IBAction)btnThrAction:(UIButton *)sender {
 
    _imgVOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_zidongdasao"];
    _imgVTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_dingdiandasao"];
    _imgVThr.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_quyudasao_an"];
    _imgVFou.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_bianjiaodasao"];
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_44"];
    if (sender!=nil) {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mapModeChangeNotice" object:@"2"];
        [self dismiss];
    }
}

- (IBAction)btnFouAction:(UIButton *)sender {
    _imgVOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_zidongdasao"];
    _imgVTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_dingdiandasao"];
    _imgVThr.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_quyudasao"];
    _imgVFou.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_bianjiaodasao_an"];
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_44"];
    if (sender!=nil) {
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mapModeChangeNotice" object:@"3"];
        [self dismiss];
    }
    
}

//1212 4*4 新增模式 5按钮 取4 arr
- (IBAction)btnFiveAction:(UIButton *)sender {
    
    _imgVOne.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_zidongdasao"];
    _imgVTwo.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_dingdiandasao"];
    _imgVThr.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_quyudasao"];
    _imgVFou.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_bianjiaodasao"];
    
    //4*4
    _imgVFive.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"mapMode_44_an"];
    
    if (sender!=nil) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mapModeChangeNotice" object:@"4"];
        [self dismiss];
    }
        
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

-(void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = Y_RGBA(0, 0, 0, 0);
        self.mapModeVBottomConstranit.constant = -160;//用于隐藏时的下滑
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.mapModeVBottomConstranit.constant = 0;
    }];
}

@end
