//
//  AreaClearView.m
//  RobotSweeper
//
//  Created by Joey on 2018/4/27.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AreaClearView.h"

@implementation AreaClearView
//区域清扫view
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
                      imgRext:(CGRect)imgRext
                    imgOfImgV:(UIImage *)img
                  bottomHight:(CGFloat)bottomH
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        _imgRect=imgRext;
        _img = img;
        _bottomHight = bottomH;
        [self addSubview:self.imgV];
        [self addSubview:self.backViewBottom];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.yesBtn];
    }
    return self;
}

#pragma mark -- getter
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.bounds = _imgRect;
        _imgV.center = self.center;
        _imgV.image = _img;
        
    }
    return _imgV;
}
- (UIView *)backViewBottom{
    if (!_backViewBottom) {
        _backViewBottom = [[UIView alloc]init];
        _backViewBottom.backgroundColor = [UIColor whiteColor];
        _backViewBottom.frame = CGRectMake(0, Y_mainH-_bottomHight, Y_mainW, _bottomHight);
        
    }
    return _backViewBottom;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelBtn.frame = CGRectMake(0, 0, Y_mainW*0.5, _bottomHight);//20 40 w h
        _cancelBtn.frame = CGRectMake(0, 0, 100, 30);
        _cancelBtn.center = CGPointMake(Y_mainW*0.25, self.frame.size.height-_bottomHight*0.5);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn setTitle:NSLocalizedString(@"取消", nil)  forState:UIControlStateNormal];
        [_cancelBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"map_quxiao"] forState:UIControlStateNormal];
        //
        _cancelBtn = [ToolOfBasic btnTextBottomAndImgTop:_cancelBtn];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _cancelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
  
    return _cancelBtn;
}
- (UIButton *)yesBtn{
    if (!_yesBtn) {
        
        _yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _yesBtn.frame = CGRectMake(Y_mainW-100-20, 40, 100, 30);
        _yesBtn.frame = CGRectMake(0, 0, 100, 30);
        _yesBtn.center = CGPointMake(Y_mainW*0.75, self.frame.size.height-_bottomHight*0.5);
        _yesBtn.backgroundColor = [UIColor whiteColor];
        [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_yesBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [_yesBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"map_queren"] forState:UIControlStateNormal];
        _yesBtn = [ToolOfBasic btnTextBottomAndImgTop:_yesBtn];
        _yesBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _yesBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

        
    }

    return _yesBtn;
}
#pragma mark -- tocuh

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
    
    int x = point.x;
    int y = point.y;
    NSLog(@"touchesBegan (x, y) is (%d, %d)", x, y);
    
    //    CGFloat xOfImg = x-Y_mainW*0.5;
    //    CGFloat yOfImg = y-Y_mainH*0.5;
//    NSLog(@"_______%@ %@__________%@ %@___________  %f ,   %f",self.frame,self.bounds,_imgV.frame,_imgV.bounds,_imgV.frame.origin.x,_imgV.frame.origin.y);

}

@end
