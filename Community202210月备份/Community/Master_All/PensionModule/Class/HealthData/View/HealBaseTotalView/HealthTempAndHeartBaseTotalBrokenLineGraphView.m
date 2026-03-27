//
//  HealthTempAndHeartBaseTotalBrokenLineGraphView.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthTempAndHeartBaseTotalBrokenLineGraphView.h"
#import <WebKit/WebKit.h> 
#define LineColor_Green          Y_ColorWith16FromRGB(0x36C8C1)
#define LineColor_Red            Y_ColorWith16FromRGB(0xFF0033)
@interface HealthTempAndHeartBaseTotalBrokenLineGraphView ()
@property (nonatomic,strong) UILabel *topTimeShowL;
@property (nonatomic,strong) UIView *topTimeShowRightOrangeV;
//
@property (nonatomic,strong) UIView *mianBackView;
@property (nonatomic,strong) AAChartView *aaChartView;
@property (nonatomic,strong) AAChartModel *aaChatModel;
@property (nonatomic,assign) NSInteger onceDataShow;//第一次加载状态 需要调用aa数据过后 做一次延时调用折线数据 不然不显示 =0+1 其他时候不做多次调用
@property (nonatomic,assign) BOOL thisAllNumDataDontZeroBool;//全0时 数据y轴范围0-43，否则33-43
@property (nonatomic,strong) NSMutableArray *saveListNumsArr;
@property (nonatomic,strong) NSMutableArray *saveListTimeStrArr;
@property (nonatomic,strong) NSMutableArray *saveListLongTimeStrArr;
//
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) UIView *bottomInfoBackView;
@property (nonatomic,strong) UILabel *bottomInfoTitleL;
@property (nonatomic,strong) UILabel *bottomInfoStatuTypeL;
@property (nonatomic,strong) UILabel *bottomInfoContentL;

@end

@implementation HealthTempAndHeartBaseTotalBrokenLineGraphView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self addSubview:self.mianBackView];
        [self.mianBackView addSubview:self.aaChartView];
        //
        [self addSubview:self.topTimeShowRightOrangeV];
        [self addSubview:self.topTimeShowL];
        //
        [self addSubview:self.bottomLineView];
        [self addSubview:self.bottomInfoBackView];
        [self.bottomInfoBackView addSubview:self.bottomInfoTitleL];
        [self.bottomInfoBackView addSubview:self.bottomInfoStatuTypeL];
        [self.bottomInfoBackView addSubview:self.bottomInfoContentL];
  

        [self setUI];
    }
    return self;
}
- (void)setUI{//10b+ 20T+30B = 60  #define  MainLinesView_Height     (300)  ||(300-60=240)mianBackView

    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomLineView.superview);
        make.height.offset(10);
    }];
    //
    [_topTimeShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTimeShowL.superview).offset(0);
        make.left.equalTo(_topTimeShowL.superview).offset(26);
        make.height.offset(20);
    }];
    [_topTimeShowRightOrangeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topTimeShowL);
        make.right.equalTo(_topTimeShowL.mas_left).offset(-5);
        make.height.width.offset(6.0);
    }];
    //
    [_bottomInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomLineView.mas_top);
        make.left.right.equalTo(_bottomLineView.superview);
        make.height.offset(30);
    }];
    [_bottomInfoTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomInfoTitleL.superview).offset(16);
        make.top.bottom.equalTo(_bottomInfoBackView);
    }];
    [_bottomInfoStatuTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomInfoTitleL.mas_right).offset(10);
        make.width.offset(32);
        make.height.offset(18);
        make.centerY.equalTo(_bottomInfoTitleL);
    }];
    [_bottomInfoContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomInfoContentL.superview).offset(-16);
        make.top.bottom.equalTo(_bottomInfoContentL.superview);
    }];
    //
    [_mianBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTimeShowL.mas_bottom).offset(5);
        make.left.equalTo(_mianBackView.superview).offset(16);
        make.right.equalTo(_mianBackView.superview).offset(-16);
        make.bottom.equalTo(_bottomInfoBackView.mas_top);
    }];
    
    [_aaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_aaChartView.superview);
    }];
}

#pragma mark ===
- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = Color_BottomLine_Gray; 
    }
    return _bottomLineView;
}
- (UIView *)topTimeShowRightOrangeV{
    if (!_topTimeShowRightOrangeV) {
        _topTimeShowRightOrangeV = [[UIView alloc]init];
        _topTimeShowRightOrangeV.backgroundColor = Color_Tip_Orange;
        _topTimeShowRightOrangeV.layer.cornerRadius = 3.0;
    }
    return _topTimeShowRightOrangeV;
}
- (UILabel *)topTimeShowL{
    if (!_topTimeShowL) {
        _topTimeShowL  = [[UILabel alloc]init];
        _topTimeShowL.textColor = Y_ColorWith16FromRGB(0x414141);
        _topTimeShowL.font = [PensionThemeManager shareManager].Pension_TextFont_14;
    }
    return _topTimeShowL;
}
//
- (UIView *)bottomInfoBackView{
    if (!_bottomInfoBackView) {
        _bottomInfoBackView = [[UIView alloc]init];
    }
    return _bottomInfoBackView;
}

- (UILabel *)bottomInfoTitleL{
    if (!_bottomInfoTitleL) {
        _bottomInfoTitleL = [[UILabel alloc]init];
        _bottomInfoTitleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _bottomInfoTitleL.font = [PensionThemeManager shareManager].Pension_TextFont_14;
        
    }
    return _bottomInfoTitleL;
}

- (UILabel *)bottomInfoStatuTypeL{//36C8C1  FF0033
    if (!_bottomInfoStatuTypeL) {
        _bottomInfoStatuTypeL = [[UILabel alloc]init];
        _bottomInfoStatuTypeL.layer.cornerRadius = 2.5;
        _bottomInfoStatuTypeL.clipsToBounds = YES;
        //初始状态绿色
        _bottomInfoStatuTypeL.font = [PensionThemeManager shareManager].Pension_TextFont_12;
        _bottomInfoStatuTypeL.textColor = Color_Stuste_NomalGreen;
        _bottomInfoStatuTypeL.backgroundColor = [Color_Stuste_NomalGreen colorWithAlphaComponent:0.2];
        _bottomInfoStatuTypeL.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomInfoStatuTypeL;
}
- (UILabel *)bottomInfoContentL{
    if (!_bottomInfoContentL) {
        _bottomInfoContentL = [[UILabel alloc]init];
        _bottomInfoContentL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _bottomInfoContentL.font = [PensionThemeManager shareManager].Pension_TextFont_14;
    }
    return _bottomInfoContentL;
}
- (UIView *)mianBackView{
    if (!_mianBackView ) {//10b+ 20T+30B  h240
        _mianBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, Screen_W-32, 240)];
    }
    return _mianBackView;
}
- (NSMutableArray *)saveListNumsArr{
    if (!_saveListNumsArr) {
        _saveListNumsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveListNumsArr;
}
- (NSMutableArray *)saveListTimeStrArr{
    if (!_saveListTimeStrArr) {
        _saveListTimeStrArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveListTimeStrArr;
}
- (NSMutableArray *)saveListLongTimeStrArr{
    if (!_saveListLongTimeStrArr) {
        _saveListLongTimeStrArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveListLongTimeStrArr;
}
#pragma mark == 公共view
- (void)setShowWithIsTempBool:(BOOL)isTempBool withAvgStr:(NSString *)shwoAvg{
    if (shwoAvg.length<=0 || isNil(shwoAvg)) {
        self.bottomInfoContentL.text = @"暂无数据";
        self.bottomInfoStatuTypeL.hidden = YES;
    }else{
        if (isTempBool) {
            self.bottomInfoContentL.text = [shwoAvg stringByAppendingString:@"℃"];
        }else{
            self.bottomInfoContentL.text = [shwoAvg stringByAppendingString:@"次/分钟"];
        }
      
        self.bottomInfoStatuTypeL.hidden = NO;
    }

}

- (void)setStatusLabelWithIntValue:(NSInteger)statusIntV{
    switch (statusIntV) {
        case 2://偏低
        {
            _bottomInfoStatuTypeL.textColor = Color_Stuste_NotNamalRed;
            _bottomInfoStatuTypeL.backgroundColor = [Color_Stuste_NotNamalRed colorWithAlphaComponent:0.2];
            _bottomInfoStatuTypeL.text = @"偏低";
        }
            break;
        case 3://红色偏高
        {
            
            _bottomInfoStatuTypeL.textColor = Color_Stuste_NotNamalRed;
            _bottomInfoStatuTypeL.backgroundColor = [Color_Stuste_NotNamalRed colorWithAlphaComponent:0.2];
            _bottomInfoStatuTypeL.text = @"偏高";
        }
            break;
            
        default:
            //绿色正常 case=1
        {
            //初始状态绿色0
            _bottomInfoStatuTypeL.textColor = Color_Stuste_NomalGreen;
            _bottomInfoStatuTypeL.backgroundColor = [Color_Stuste_NomalGreen colorWithAlphaComponent:0.2];
            _bottomInfoStatuTypeL.text = @"正常";
        }
            break;
    }
}
#pragma mark === 温度
- (void)fillTempDayTypeWithData:(HealthGetTempOrHeartOneDayModel *)data{
    if (isNil(data)) {
        return;
    }
    self.topTimeShowL.text = @"当日";
    self.bottomInfoTitleL.text = @"日平均体温";
    [self setShowWithIsTempBool:YES withAvgStr:data.temptAvg];
    [self setStatusLabelWithIntValue:[data.tempStatus integerValue]];
    [self setTempLineViewWithTempDataArr:data.list];
    if (self.onceDataShow==1) {
        [self performSelector:@selector(setTempLineViewWithTempDataArr:) withObject:data.list  afterDelay:0.5];
    }

}
- (void)fillTempWeakTypeWithData:(HealthGetTempOrHeartOneDayModel *)data{
    if (isNil(data)) {
        return;
    }
    self.topTimeShowL.text = @"本周";
    self.bottomInfoTitleL.text = @"周平均体温";
    [self setShowWithIsTempBool:YES  withAvgStr:data.temptAvg];
    [self setStatusLabelWithIntValue:[data.tempStatus integerValue]];
    [self setTempLineViewWithTempDataArr:data.list];
}
- (void)fillTempMonthTypeWithData:(HealthGetTempOrHeartOneDayModel *)data{
    if (isNil(data)) {
        return;
    }
    self.topTimeShowL.text = @"本月";
    self.bottomInfoTitleL.text = @"月平均体温";
    [self setShowWithIsTempBool:YES withAvgStr:data.temptAvg];
    [self setStatusLabelWithIntValue:[data.tempStatus integerValue]];
    [self setTempLineViewWithTempDataArr:data.list];
}


#pragma mark === 心率
- (void)fillHeartDayTypeWithData:(HealthGetTempOrHeartOneDayModel *)data{
    if (isNil(data)) {
        return;
    }
    self.topTimeShowL.text = @"当日";
    self.bottomInfoTitleL.text = @"日平均心率";
    [self setShowWithIsTempBool:NO withAvgStr:data.silentHeartAvg];
    [self setStatusLabelWithIntValue:[data.heartRateStatus integerValue]];
    [self setHeartLineViewWithHeartDataArr:data.list];
    if (self.onceDataShow==1) {
        [self performSelector:@selector(setHeartLineViewWithHeartDataArr:) withObject:data.list  afterDelay:0.5];
    }
    
}
- (void)fillHeartWeakTypeWithData:(HealthGetTempOrHeartOneWeakModel *)data{
    if (isNil(data)) {
        return;
    }
    self.topTimeShowL.text = @"本周";
    self.bottomInfoTitleL.text = @"周平均心率";
    [self setShowWithIsTempBool:NO withAvgStr:data.silentHeartAvg];
    [self setStatusLabelWithIntValue:[data.heartRateStatus integerValue]];
    [self setHeartLineViewWithHeartDataArr:data.list];
}
- (void)fillHeartMonthTypeWithData:(HealthGetTempOrHeartOneMonthModel *)data{
    if (isNil(data)) {
        return;
    }
    self.topTimeShowL.text = @"本月";
    self.bottomInfoTitleL.text = @"月平均心律";
    [self setShowWithIsTempBool:NO withAvgStr:data.silentHeartAvg];
    [self setStatusLabelWithIntValue:[data.heartRateStatus integerValue]];
    [self setHeartLineViewWithHeartDataArr:data.list];
}
#pragma mark ===  折线部分
 

- (void)setTempLineViewWithTempDataArr:(NSArray *)list{
    if (list.count<=0) {
        return;
    }
    [self drawTheMainLineWithIsTempBool:YES withDataArr:list];

}
- (void)setHeartLineViewWithHeartDataArr:(NSArray *)list{
    if (list.count<=0) {
        return;
    }
    [self drawTheMainLineWithIsTempBool:NO withDataArr:list];
}
- (void)drawTheMainLineWithIsTempBool:(BOOL)isTempType withDataArr:(NSArray *)list{
    
    //折线
    [self.saveListNumsArr removeAllObjects];
    [self.saveListTimeStrArr removeAllObjects];
    [self.saveListLongTimeStrArr removeAllObjects];
    
    for (int i = 0; i < list.count; i ++) {
        healthGetTempOrHeartListObjModel *model = list[i];
        
        /** test
         if ( [model.healthData doubleValue] == 0) {
         //空数据换成造假数据
         [self.saveListNumsArr addObject:@([Tool getRandomNumber:34 to:42])];
         }else{
         [self.saveListNumsArr addObject:@([model.healthData doubleValue])];
         }
         */
        if (isTempType) {
            [self.saveListNumsArr addObject:@([model.healthData doubleValue])];
        }else{
            [self.saveListNumsArr addObject:@([model.healthData integerValue])];
        }
        [self.saveListTimeStrArr addObject:[TextShowWithModelStr textShowWithModelStr:model.timeValue]];
        [self.saveListLongTimeStrArr addObject:[TextShowWithModelStr textShowWithModelStr:model.timeTitle]];
        //全部数据0 y轴min不一样
        if ( [model.healthData intValue] != 0 ) {//
            self.thisAllNumDataDontZeroBool = YES;
        }
        
    }
    //一条线的元素数据
    AASeriesElement *aaSe = [[AASeriesElement alloc]init];
    [aaSe setData:self.saveListNumsArr];
    [aaSe setLineWidth:@(1.0)];
    [aaSe setColor:@"#36C8C1"];
    if (isTempType) {
        [aaSe setName:@"温度"];
    }else{
        [aaSe setName:@"心率"];
    }
    
    //总坐标UI数据
    self.aaChatModel = [[AAChartModel alloc]init];
    [ self.aaChatModel  setSeries:@[aaSe]];
    [ self.aaChatModel  setCategories:self.saveListTimeStrArr];
    if (isTempType) {
        [ self.aaChatModel  setTooltipValueSuffix:@"℃"];///设置浮动提示框单位后缀
        [ self.aaChatModel  setYAxisMax:@(43.0)];
        if (self.thisAllNumDataDontZeroBool) {
//            [ self.aaChatModel  setYAxisMin:@(33.0)];
            [ self.aaChatModel  setYAxisMin:@(0.0)];
        }else{
            [ self.aaChatModel  setYAxisMin:@(0.0)];
            
        }
    }else{
        [ self.aaChatModel  setTooltipValueSuffix:@"次/分钟"];///设置浮动提示框单位后缀
        [ self.aaChatModel  setYAxisMax:@(200)];
        if (self.thisAllNumDataDontZeroBool) {
//            [ self.aaChatModel  setYAxisMin:@(50)];
            [ self.aaChatModel  setYAxisMin:@(0)];
        }else{
            [ self.aaChatModel  setYAxisMin:@(0)];
            
        }
    }
    [ self.aaChatModel  setChartType:AAChartTypeLine];
    [ self.aaChatModel  setTitle:@""];
    [ self.aaChatModel  setSubtitle:@""];
    [ self.aaChatModel  setLegendEnabled:NO];//legendEnabledSet下面按钮是否显示
    [ self.aaChatModel  setYAxisVisible:NO];//y皱显示隐藏
    [ self.aaChatModel  setMarkerRadius:@(3.0)];//折线连接点的半径长度 圆点的大小
    [ self.aaChatModel  setXAxisCrosshair: [AACrosshair crosshairWithColor:@"#FF0033"
                                                                 dashStyle:AAChartLineDashStyleTypeLongDashDot
                                                                     width:@(0.5)] ];//准星线
    //show
    //[self.aaChartView aa_drawChartWithChartModel: nil ];//清空
    if (isNotNil( self.aaChatModel )) {
        [self.aaChartView aa_drawChartWithChartModel: self.aaChatModel ];
        self.onceDataShow += 1;
    }
}




#pragma mark ====
- (AAChartView *)aaChartView{
    if (!_aaChartView) {
        _aaChartView = [[AAChartView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 240)];
        
        /**
         折线上的点的点击事件
         获取图表上的手指点击及滑动事件
         You should set moveOverEventBlock before drawing chart
         */
        WEAKSELF
        [_aaChartView moveOverEventHandler:^(AAChartView *aaChartView,
                                             AAMoveOverEventMessageModel *message) {
            NSDictionary *messageDic = @{
                @"category":message.category,
                @"index":@(message.index),
                @"name":message.name,
                @"offset":message.offset,
                @"x":message.x,
                @"y":message.y
            };
            
            NSString *str1 = [NSString stringWithFormat:@"moveOverEventHandler  1: %@\n",
                              message.name];
            NSString *str2 = [NSString stringWithFormat:@"moveOverEventHandler  2: %@",
                              messageDic];
            NSLog(@"获取图表上的手指点击及滑动事件 %@ %@",str1, str2);
            
            NSString *newTopShowTIme = [NSString stringWithFormat:@"%@", weakSelf.saveListLongTimeStrArr[message.index]];
            //         self->_topTimeShowL.text = newTopShowTIme;
            weakSelf.topTimeShowL.text = newTopShowTIme;
        }];
        
    }
    return _aaChartView;
}



#pragma mark ====
 
@end
