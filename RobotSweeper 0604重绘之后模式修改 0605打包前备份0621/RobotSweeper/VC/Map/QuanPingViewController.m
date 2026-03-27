//
//  QuanPingViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/11.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "QuanPingViewController.h"
//暂时不用
@interface QuanPingViewController ()
@property (nonatomic,strong)UIButton *returnBtn;
@property (nonatomic,strong)UIImageView *mapImgV;
@property (nonatomic,strong)NSTimer *mapImgChangeTimer;
@property (nonatomic,strong)UIImageView *mapLocationImgV;

@end

@implementation QuanPingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapImgV];
    [self.view addSubview:self.mapLocationImgV];
    [self delayChangeImg];
    _mapImgChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayChangeImg) userInfo:nil repeats:YES];
    /**
    _mapImgChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self delayChangeImg];//定时更新img
    }];
    */
    [self.view addSubview:self.returnBtn];
    CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
    [_returnBtn setTransform:transform];//退出按钮转向
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_mapImgChangeTimer) {
        [_mapImgChangeTimer invalidate];
        _mapImgChangeTimer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)delayChangeImg{
    if ([DataManager shareDataManager].mapImgBeforeData!=nil) {
        UIImage *dataImg = [UIImage imageWithData:[DataManager shareDataManager].mapImgBeforeData];
        CGFloat sourceImgWidth = dataImg.size.width;
        CGFloat sourceImgHeight = dataImg.size.height;
        
        _mapImgV.image = dataImg;
        CGFloat currentImgWidth = _mapImgV.frame.size.width;
        CGFloat currentImgHeight =  _mapImgV.frame.size.height;
        //全屏显示所变化的宽高比例
        NSLog(@"s_w %f H %f   ; cu_w %f h %f  ;///sw=%f   sh=%f",sourceImgWidth,sourceImgHeight,currentImgWidth,currentImgHeight,sourceImgWidth/currentImgWidth,sourceImgHeight/currentImgHeight);
        
        CGFloat sW = 1;
        CGFloat sH = 1;
        if (sourceImgWidth<=currentImgWidth) {
            sW = currentImgWidth/sourceImgWidth;
        }
        if (sourceImgHeight<=currentImgHeight) {
            sH = currentImgHeight/sourceImgHeight;
        }
        
        CGFloat posX = [DataManager shareDataManager].posX;
        CGFloat posY = [DataManager shareDataManager].posY;
        CGFloat mapR = [DataManager shareDataManager].mapRightEnd;
        CGFloat mapT = [DataManager shareDataManager].mapTopEnd;
        CGFloat mapW = [DataManager shareDataManager].mapRightEnd-[DataManager shareDataManager].mapLeftEnd;
        CGFloat mapH = [DataManager shareDataManager].mapTopEnd-[DataManager shareDataManager].mapBottomEnd;

        
        if (sW<sH) {
            sH = sW;
        }else{
            sW = sH;
        }
        //let x :CGFloat = CGFloat(xm)-xC+CGFloat(wImg)*0.5
        //var y :CGFloat = CGFloat(-ym)+yC+CGFloat(hImg)*0.5
        _mapLocationImgV.center = CGPointMake((posX-mapR+mapW*0.5)*sW+Y_mainW*0.5, (-posY+mapT-mapH*0.5)*sH+Y_mainH*0.5);
 
        _mapLocationImgV.transform = CGAffineTransformIdentity;
        CGFloat t = (DataManager.shareDataManager.theta) / 180;
        _mapLocationImgV.transform = CGAffineTransformMakeRotation( -M_PI*t );
//        NSLog(@"%f %@", t,_mapLocationImgV.transform);
    
        
    }
}
#pragma mark -- action
- (void)returnBtnAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnBtn.frame = CGRectMake(Y_mainW-80, 40, 60, 60);
        _returnBtn.backgroundColor = [UIColor clearColor];
        [_returnBtn addTarget:self action:@selector(returnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_returnBtn setTitle:@"退出全屏" forState:UIControlStateNormal];
          [_returnBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _returnBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _returnBtn;
}

- (UIImageView *)mapImgV{
    if (!_mapImgV) {
        _mapImgV = [[UIImageView alloc]init];
        _mapImgV.frame = CGRectMake(0, 0, Y_mainW, Y_mainH);
        _mapImgV.backgroundColor = Y_RGB(245, 245, 245);
        _mapImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _mapImgV;
}




- (UIImageView *)mapLocationImgV{
    if (!_mapLocationImgV) {
        _mapLocationImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _mapLocationImgV.center = self.view.center;
        _mapLocationImgV.image = [UIImage imageNamed:@"robotLocation_colour"];

    }
    return _mapLocationImgV;
}
@end
