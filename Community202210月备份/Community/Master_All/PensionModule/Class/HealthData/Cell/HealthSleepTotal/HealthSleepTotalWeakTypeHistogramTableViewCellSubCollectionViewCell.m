//
//  HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell.h"

//allH==200 bottom-50  色块用150_h
#define  SignBtnsAll_H  (150)
#define  SignBtn_W  (10)

static double allMaxSleepTimeMinNum = (14.0*60);//总睡眠最多记录14小时 做成分钟数据

@interface HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell ()
//
@property (nonatomic,strong) UIView *signBtnsBackV;
@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UIView *twoView;
@property (nonatomic,strong) UIView *thrView;
//
@property (nonatomic,strong) UIView *bottomBackV;
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) UILabel *bottimDayTimeShowL;
@property (nonatomic,strong) UILabel *bottimWeakNumShowL;

@end

@implementation HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell

- (void)fillDataWithOneDayModel:(HealthGetSleepOneDayModel *)oneDayModel{
    if (isNil(oneDayModel)) {
        return;
    }
    self.bottimDayTimeShowL.text = [TextShowWithModelStr textShowWithModelStr:oneDayModel.timeValue];
    self.bottimWeakNumShowL.text = [TextShowWithModelStr textShowWithModelStr:oneDayModel.timeWeek];
//    self.bottimWeakNumShowL.text = @"";//周文本暂无
    
    //比例
    double dtP = (double)(oneDayModel.deepSleepTime)/allMaxSleepTimeMinNum;
    double ltP = (double)(oneDayModel.lightSleepTime)/allMaxSleepTimeMinNum;
    double atP = (double)(oneDayModel.wakeUpTime)/allMaxSleepTimeMinNum;
    //高度更新
    [self.oneView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(dtP*SignBtnsAll_H);
    }];
    [self.twoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ltP*SignBtnsAll_H);
    }];
    [self.thrView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(atP*SignBtnsAll_H);
    }];
}
- (void)setSubViewColorIsTouchTypeBool:(BOOL)isTouchBool{
    if (isTouchBool) {
        //橘色
        _oneView.backgroundColor = Color_HealthShow_SleepType_Orange_Deep;
        _twoView.backgroundColor = Color_HealthShow_SleepType_Orange_Light;
        _thrView.backgroundColor = Color_HealthShow_SleepType_Orange_Awake;
    }else{
        //绿色
        _oneView.backgroundColor = Color_HealthShow_SleepType_Green_Deep;
        _twoView.backgroundColor = Color_HealthShow_SleepType_Green_Light;
        _thrView.backgroundColor = Color_HealthShow_SleepType_Green_Awake;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.signBtnsBackV];
        [self.contentView addSubview:self.bottomBackV];
        //
        [self.signBtnsBackV addSubview:self.oneView];
        [self.signBtnsBackV addSubview:self.twoView];
        [self.signBtnsBackV addSubview:self.thrView];
        //
        [self.bottomBackV addSubview:self.bottomLineView];
        [self.bottomBackV addSubview:self.bottimDayTimeShowL];
        [self.bottomBackV addSubview:self.bottimWeakNumShowL];
        //
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_signBtnsBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(150);
        make.left.right.top.equalTo(_signBtnsBackV.superview);
    }];
    [_bottomBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomBackV.superview);
        make.top.equalTo(_signBtnsBackV.mas_bottom);
    }];
    //
    [self signAllViewUI];
    [self bottomAllViewUI];
}
- (void)signAllViewUI{
    [_oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_oneView.superview);
        make.width.offset(SignBtn_W);
        make.bottom.equalTo(_oneView.superview);
        make.height.offset(0.1);
    }];
    [_twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_twoView.superview);
        make.width.offset(SignBtn_W);
        make.bottom.equalTo(_oneView.mas_top);
        make.height.offset(0.1);
    }];
    [_thrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thrView.superview);
        make.width.offset(SignBtn_W);
        make.bottom.equalTo(_twoView.mas_top);
        make.height.offset(0.1);
    }];
    
}
- (void)bottomAllViewUI{
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_bottomLineView.superview);
        make.height.offset(0.5);
    }];
    [_bottimDayTimeShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottimDayTimeShowL.superview);
        make.top.equalTo(_bottomLineView.mas_bottom);
        make.height.offset(25);
    }];
    [_bottimWeakNumShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottimWeakNumShowL.superview);
        make.top.equalTo(_bottimDayTimeShowL.mas_bottom);
    }];
}


#pragma mark ===
- (UIView *)signBtnsBackV{
    if (!_signBtnsBackV) {
        _signBtnsBackV = [[UIView alloc]init];
        _signBtnsBackV.backgroundColor = [UIColor clearColor];
    }
    return _signBtnsBackV;
}
- (UIView *)bottomBackV{
    if (!_bottomBackV) {
        _bottomBackV = [[UIView alloc]init];
        _bottomBackV.backgroundColor = [UIColor clearColor];
    }
    return _bottomBackV;
}
#pragma mark ===
//top_sub

- (UIView *)oneView{
    if (!_oneView) {
        _oneView = [[UIView alloc]init];
        _oneView.backgroundColor = Color_HealthShow_SleepType_Green_Deep;
    }
    return _oneView;
}
- (UIView *)twoView{
    if (!_twoView) {
        _twoView = [[UIView alloc]init];
        _twoView.backgroundColor = Color_HealthShow_SleepType_Green_Light;
    }
    return _twoView;
}
- (UIView *)thrView{
    if (!_thrView) {
        _thrView = [[UIView alloc]init];
        _thrView.backgroundColor = Color_HealthShow_SleepType_Green_Awake;
    }
    return _thrView;
}
#pragma mark ===
//bottom_sub
- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = Y_ColorWith16FromRGB(0xC5C9D4);
    }
    return _bottomLineView;
}

- (UILabel *)bottimDayTimeShowL{
    if (!_bottimDayTimeShowL) {
        _bottimDayTimeShowL = [[UILabel alloc]init];
        _bottimDayTimeShowL.textColor = Color_51BlackColor;
        _bottimDayTimeShowL.textAlignment = NSTextAlignmentCenter;
        _bottimDayTimeShowL.font = [PensionThemeManager shareManager].Pension_TextFont_11;
    }
    return _bottimDayTimeShowL;
}

- (UILabel *)bottimWeakNumShowL{
    if (!_bottimWeakNumShowL) {
        _bottimWeakNumShowL = [[UILabel alloc]init];
        _bottimWeakNumShowL.textColor = Color_51BlackColor;
        _bottimWeakNumShowL.textAlignment = NSTextAlignmentCenter;
        _bottimWeakNumShowL.font = [PensionThemeManager shareManager].Pension_TextFont_11;
    }
    return _bottimWeakNumShowL;
}
#pragma mark ===
 
@end
