//
//  ClearnMapDetailsViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/11.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "ClearnMapDetailsViewController.h"

@interface ClearnMapDetailsViewController ()

@property (nonatomic,strong)UIView *topBackView;
@property (nonatomic,strong)UIView *bottomBackView;

@property (nonatomic,strong)UIView *timeView;
@property (nonatomic,strong)UILabel *timeTitleL;
@property (nonatomic,strong)UILabel *timeContentL;

@property (nonatomic,strong)UIView *squareView;
@property (nonatomic,strong)UILabel *squareTitleL;
@property (nonatomic,strong)UILabel *squareContentL;

@property (nonatomic,strong)UIView *modeView;
@property (nonatomic,strong)UILabel *modeTitleL;
@property (nonatomic,strong)UILabel *modeContentL;

@property (nonatomic,strong)UIView *strongView;
@property (nonatomic,strong)UILabel *strongTitleL;
@property (nonatomic,strong)UILabel *strongContentL;

@property (nonatomic,strong)UILabel *bottomTimeL;
@property (nonatomic,strong)UIImageView *bottomImgV;
@end

@implementation ClearnMapDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"地图详情", nil);
 
    [self initView];
    [self initData];
}
- (void)initData{
    

     NSString *strOfStarTime = [_dicOfClearnMapDetails objectForKey:@"dataStart"];
     NSString *strOfEndTime = [_dicOfClearnMapDetails objectForKey:@"dataEnd"];
    NSString *strOfTime = [NSString stringWithFormat:@"%@至%@",[strOfStarTime substringWithRange:NSMakeRange(0, 16)],[strOfEndTime substringWithRange:NSMakeRange(11, 5)]];
    if (self.title.length>5) {
          strOfTime = [NSString stringWithFormat:@"%@ - %@",[strOfStarTime substringWithRange:NSMakeRange(0, 16)],[strOfEndTime substringWithRange:NSMakeRange(11, 5)]];
    }else{
          strOfTime = [NSString stringWithFormat:@"%@至%@",[strOfStarTime substringWithRange:NSMakeRange(0, 16)],[strOfEndTime substringWithRange:NSMakeRange(11, 5)]];
    }
  
    
  //4个
//    NSString *strOfWorkTime = [_dicOfClearnMapDetails objectForKey:@"logContent"];
//    NSString *strOfWorkTime = [NSString stringWithFormat:@"%@",[ToolOfBasic  timeForMinuteswithTalSseconds:[[_dicOfClearnMapDetails objectForKey:@"logContent"] intValue]]];
    
     NSString *strOfWorkTime = [NSString stringWithFormat:@"%@",[_dicOfClearnMapDetails objectForKey:@"logContent"]];
    
    NSString *strOfArea = [NSString stringWithFormat:@"%@",[_dicOfClearnMapDetails objectForKey:@"logCleanArea"]];
  
     NSString *strOfMode = @"自动清扫";
    switch ([[_dicOfClearnMapDetails objectForKey:@"logCleanType"] intValue]) {
        case 1://规划自动
            strOfMode = [DataManager shareDataManager].mapModeArrMain.firstObject;//[0]//var mapModeArrMain = ["自动清扫","定点清扫","区域清扫","边角清扫"]
            break;
        case 2:
            strOfMode = [DataManager shareDataManager].mapModeArrMain[3];
//            strOfMode = @"沿边打扫";;
            break;
        case 3:
            strOfMode = [DataManager shareDataManager].mapModeArrMain[2];
//            strOfMode = @"区域打扫";;
            break;
        case 4://重点定点
            strOfMode = [DataManager shareDataManager].mapModeArrMain[1];
            break;
        case 5://4*4清扫模式 1212新增 5种模式 
            strOfMode = [DataManager shareDataManager].mapModeArrMain[4];
            break;
        case 6://20190527 专扫模式
            strOfMode = [DataManager shareDataManager].mapModeArrMain[5];
            break;
 
        default:
            strOfMode = [DataManager shareDataManager].mapModeArrMain.firstObject;//[0]
            break;
    }
    
    NSString *strOfStrong = NSLocalizedString(@"标准", nil) ;
    switch ([[_dicOfClearnMapDetails objectForKey:@"logCleanStrength"] intValue]) {
        case 1:
            strOfStrong = NSLocalizedString(@"标准", nil);
            break;
        case 2:
            strOfStrong = NSLocalizedString(@"静音", nil);
            break;
        case 3:
            strOfStrong = NSLocalizedString(@"强力", nil);
            break;
        default:
            strOfStrong = NSLocalizedString(@"标准", nil) ;
            break;
    }
    
  //top4个
    
    if ([strOfWorkTime isEqualToString:@"0"]) {
        strOfWorkTime = @"小于1";
        if (self.title.length>5) {
             strOfWorkTime = @"< 1 ";
        }
    }
    if([strOfArea isEqualToString:@"0"]){
        strOfArea = @"小于1";
        if (self.title.length>5) {
            strOfArea = @"< 1 ";
        }
    }
    if (self.title.length>5) {
       
        _timeContentL.text = [strOfWorkTime stringByAppendingString:@"Min"];
        _squareContentL.text = [strOfArea stringByAppendingString:@"sq.m.s"];//sq.m.

    }else{
         _timeContentL.text = [strOfWorkTime stringByAppendingString:@"分钟"];
        _squareContentL.text = [strOfArea stringByAppendingString:@"平方米"];

    }
  
    _modeContentL.text = strOfMode;
    _strongContentL.text = strOfStrong;
    //日期
    _bottomTimeL.text = strOfTime;
   
    if([[_dicOfClearnMapDetails allKeys] containsObject:@"logCleanPictureUrl"]){
        //图
        [_bottomImgV  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_dicOfClearnMapDetails objectForKey:@"logCleanPictureUrl"]]]];
    }
    
    
}
- (void)initView{
    [self.view addSubview:self.topBackView];
    [self.view addSubview:self.bottomBackView];
    
    [_topBackView addSubview:self.timeView];
    [_topBackView addSubview:self.squareView];
    [_topBackView addSubview:self.modeView];
    [_topBackView addSubview:self.strongView];
    
    [_timeView addSubview:self.timeContentL];
    [_timeView addSubview:self.timeTitleL];
    [_squareView addSubview:self.squareContentL];
    [_squareView addSubview:self.squareTitleL];
    [_modeView addSubview:self.modeContentL];
    [_modeView addSubview:self.modeTitleL];
    [_strongView addSubview:self.strongContentL];
    [_strongView addSubview:self.strongTitleL];
    
    //
    [_bottomBackView addSubview:self.bottomTimeL];
    [_bottomBackView addSubview:self.bottomImgV];
    [self setYuesu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- yuesu
- (void)setYuesu{
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topBackView).multipliedBy(0.5);
        make.centerY.equalTo(_topBackView).multipliedBy(0.5);
        make.width.offset(_topBackView.width*0.5-20);
        make.height.offset(_topBackView.height*0.5-10);
    }];
    [_squareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topBackView).multipliedBy(1.5);
        make.centerY.equalTo(_topBackView).multipliedBy(0.5);
        make.width.offset(_topBackView.width*0.5-20);
        make.height.offset(_topBackView.height*0.5-10);
    }];
    [_modeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topBackView).multipliedBy(0.5);
        make.centerY.equalTo(_topBackView).multipliedBy(1.5);
        make.width.offset(_topBackView.width*0.5-20);
        make.height.offset(_topBackView.height*0.5-10);
    }];
    [_strongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topBackView).multipliedBy(1.5);
        make.centerY.equalTo(_topBackView).multipliedBy(1.5);
        make.width.offset(_topBackView.width*0.5-20);
        make.height.offset(_topBackView.height*0.5-10);
    }];
    
    //
    [_timeContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeView);
        make.top.equalTo(_timeView.mas_top);
        make.width.equalTo(_timeView.mas_width);
        make.height.equalTo(_timeView.mas_height).multipliedBy(0.6);
    }];
    [_timeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeView);
        make.bottom.equalTo(_timeView.mas_bottom);
        make.width.equalTo(_timeView.mas_width);
        make.height.equalTo(_timeView.mas_height).multipliedBy(0.4);
    }];
    [_squareContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_squareView);
        make.top.equalTo(_squareView.mas_top);
        make.width.equalTo(_squareView.mas_width);
        make.height.equalTo(_squareView.mas_height).multipliedBy(0.6);
    }];
    [_squareTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_squareView);
        make.bottom.equalTo(_squareView.mas_bottom);
        make.width.equalTo(_squareView.mas_width);
        make.height.equalTo(_squareView.mas_height).multipliedBy(0.4);
    }];
    
    [_modeContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_modeView);
        make.top.equalTo(_modeView.mas_top);
        make.width.equalTo(_modeView.mas_width);
        make.height.equalTo(_modeView.mas_height).multipliedBy(0.6);
    }];
    [_modeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_modeView);
        make.bottom.equalTo(_modeView.mas_bottom);
        make.width.equalTo(_modeView.mas_width);
        make.height.equalTo(_modeView.mas_height).multipliedBy(0.4);
    }];
    [_strongContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_strongView);
        make.top.equalTo(_strongView.mas_top);
        make.width.equalTo(_strongView.mas_width);
        make.height.equalTo(_strongView.mas_height).multipliedBy(0.6);
    }];
    [_strongTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_strongView);
        make.bottom.equalTo(_strongView.mas_bottom);
        make.width.equalTo(_strongView.mas_width);
        make.height.equalTo(_strongView.mas_height).multipliedBy(0.4);
    }];
  
    
    
//    _timeContentL.text = @"111分钟";
//    _strongContentL.text = @"标准";
//    _squareContentL.text = @"666平方米";
//    _modeContentL.text = @"自动打扫";
//    _timeView.backgroundColor = [UIColor redColor];
//    _squareView.backgroundColor = [UIColor blueColor];
//    _modeView.backgroundColor = [UIColor cyanColor];
//    _strongView.backgroundColor = [UIColor brownColor];
//    _topBackView.backgroundColor = [UIColor grayColor];
    
    
    //
    [_bottomTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBackView.mas_left).offset(10);
        make.top.equalTo(_bottomBackView.mas_top);
        make.width.equalTo(_bottomBackView.mas_width).offset(-10);
        make.height.offset(30);
    }];
    
    [_bottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBackView.mas_left);
        make.top.equalTo(_bottomTimeL.mas_bottom);
        make.width.equalTo(_bottomBackView.mas_width);
        make.bottom.equalTo(_bottomBackView.mas_bottom);;
    }];
}

#pragma mark -- 
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
        _topBackView.frame = CGRectMake(10, 100, Y_mainW-20, Y_mainH*0.3);
        _topBackView.backgroundColor = [UIColor whiteColor];
    }
    return _topBackView;
}
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
        _bottomBackView.frame = CGRectMake(10, 100+Y_mainH*0.3, Y_mainW-20, Y_mainH*0.7-110);
        
    }
    return _bottomBackView;
}

//
- (UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc]init];
        _timeView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;//[UIColor lightGrayColor].CGColor;
        _timeView.layer.borderWidth = 1;
    }
    return _timeView;
}
- (UILabel *)timeTitleL{
    if (!_timeTitleL) {
        _timeTitleL = [[UILabel alloc]init];
        _timeTitleL.font = [UIFont systemFontOfSize:16];
        _timeTitleL.textAlignment = NSTextAlignmentCenter;
        _timeTitleL.text = NSLocalizedString(@"工作时长", nil) ;
    }
    return _timeTitleL;
}
- (UILabel *)timeContentL{
    
    if (!_timeContentL) {
        _timeContentL = [[UILabel alloc]init];
        _timeContentL.font = [UIFont systemFontOfSize:20];
        _timeContentL.numberOfLines = 2;
        _timeContentL.textAlignment = NSTextAlignmentCenter;
    }
    return _timeContentL;
}
//
- (UIView *)squareView{
    if (!_squareView) {
        _squareView = [[UIView alloc]init];
        _squareView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;//[UIColor lightGrayColor].CGColor;
        _squareView.layer.borderWidth = 1;
    }
    return _squareView;
}
- (UILabel *)squareTitleL{
    if (!_squareTitleL) {
        _squareTitleL = [[UILabel alloc]init];
        _squareTitleL.font = [UIFont systemFontOfSize:16];
        _squareTitleL.textAlignment = NSTextAlignmentCenter;
        _squareTitleL.text = NSLocalizedString(@"清扫范围", nil);
        
    }
    return _squareTitleL;
}
- (UILabel *)squareContentL{
    if (!_squareContentL) {
        _squareContentL = [[UILabel alloc]init];
        _squareContentL.font = [UIFont systemFontOfSize:20];
        _squareContentL.numberOfLines = 2;
        _squareContentL.textAlignment = NSTextAlignmentCenter;
    }
    return _squareContentL;
}
//
- (UIView *)modeView{
    if (!_modeView) {
        _modeView = [[UIView alloc]init];
        _modeView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;//[UIColor lightGrayColor].CGColor;
        _modeView.layer.borderWidth = 1;
    }
    return _modeView;
}
- (UILabel *)modeTitleL{
    if (!_modeTitleL) {
        _modeTitleL = [[UILabel alloc]init];
        _modeTitleL.font = [UIFont systemFontOfSize:16];
        _modeTitleL.textAlignment = NSTextAlignmentCenter;
        _modeTitleL.text = NSLocalizedString(@"清扫模式", nil);
    }
    return _modeTitleL;
}
- (UILabel *)modeContentL{
    
    if (!_modeContentL) {
        _modeContentL = [[UILabel alloc]init];
        _modeContentL.font = [UIFont systemFontOfSize:20];
        _modeContentL.numberOfLines = 2;
        _modeContentL.textAlignment = NSTextAlignmentCenter;
    }
    return _modeContentL;
}
//
- (UIView *)strongView{
    if (!_strongView) {
        _strongView = [[UIView alloc]init];
        _strongView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;//[UIColor lightGrayColor].CGColor;
        _strongView.layer.borderWidth = 1;
    }
    return _strongView;
}
- (UILabel *)strongTitleL{
    if (!_strongTitleL) {
        _strongTitleL = [[UILabel alloc]init];
        _strongTitleL.font = [UIFont systemFontOfSize:16];
        _strongTitleL.textAlignment = NSTextAlignmentCenter;
        _strongTitleL.text = NSLocalizedString(@"清扫力度", nil);
        
    }
    return _strongTitleL;
}
- (UILabel *)strongContentL{
    if (!_strongContentL) {
        _strongContentL = [[UILabel alloc]init];
        _strongContentL.font = [UIFont systemFontOfSize:20];
        _strongContentL.numberOfLines = 2;
        _strongContentL.textAlignment = NSTextAlignmentCenter;
        
    }
    return _strongContentL;
}
#pragma mark -- 
- (UILabel *)bottomTimeL{
    if (!_bottomTimeL) {
        _bottomTimeL = [[UILabel alloc]init];
        _bottomTimeL.font = [UIFont systemFontOfSize:16];
        _bottomTimeL.textAlignment = NSTextAlignmentLeft;
        _bottomTimeL.backgroundColor = [UIColor whiteColor];
        _bottomTimeL.text = @"本记录日期时间";
        
    }
    return _bottomTimeL;
    
}
- (UIImageView *)bottomImgV{
    if (!_bottomImgV) {
        _bottomImgV = [[UIImageView alloc]init];
        _bottomImgV.backgroundColor = [UIColor whiteColor];
        _bottomImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomImgV;
}

@end
