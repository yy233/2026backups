//
//  GuestTempCodeShowVc.m
//  Community
//
//  Created by 余莹 on 2021/10/26.
// 

#import "GuestTempCodeShowVc.h"

@interface GuestTempCodeShowVc ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *timeDelineShowLabel;
@property (nonatomic,strong) UIView *qrBackView;
@property (nonatomic,strong) UIImageView *qrInfoImgV;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation GuestTempCodeShowVc

 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"访客临时通行码";
    [self initView];
    [self initShowQrData];
    
}
- (void)initView{
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.qrBackView];
    [self.view addSubview:self.footerView];
    [self.qrBackView addSubview:self.timeDelineShowLabel];
    [self.qrBackView addSubview:self.qrInfoImgV];
    [self setUI];
    _qrBackView.backgroundColor = [UIColor whiteColor];
    _qrBackView.layer.cornerRadius = 10;
    _qrBackView.layer.masksToBounds = YES;
}
- (void)initShowQrData{
    //展示文本
    NSString *showBottomText = [NSString stringWithFormat:@"———— 该二维码将在%ld分钟内有效 ————",self.tempTimeNum];
    if (self.tempTimeBeginInfoStr.length>0) {
        showBottomText = [NSString stringWithFormat:@"该二维码将在%@后%ld分钟内有效",self.tempTimeBeginInfoStr,self.tempTimeNum];
    }else{
        showBottomText = [NSString stringWithFormat:@"———— 该二维码将在%ld分钟内有效 ————",self.tempTimeNum];
    }
    self.timeDelineShowLabel.text = showBottomText;

    //
    NSString *qrOkStr = [NSString stringWithFormat:@"{\\\"visitorId\\\":%@}",self.visitorId];
    UIImage *qrImg = [CreatQrCodeImgTool creatQrCodeImgWithOnlyStr:qrOkStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.qrInfoImgV.image = qrImg;
    });
 
    
}
- (void)setUI{
    float tipLabelH = 45;
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tipLabel.superview);
        make.height.offset(tipLabelH);
    }];
    
    [_qrBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_qrBackView.superview);
        make.centerY.equalTo(_qrBackView.superview).multipliedBy(0.9);
        make.left.equalTo(_qrBackView.superview).offset(16);
        make.right.equalTo(_qrBackView.superview).offset(-16);
        make.height.equalTo(_qrBackView.superview).multipliedBy(0.5);
    
    }];
    [_qrInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_qrInfoImgV.superview).multipliedBy(0.6);
        make.height.equalTo(_qrInfoImgV.mas_width);
        make.centerX.equalTo(_qrInfoImgV.superview);
        make.centerY.equalTo(_qrInfoImgV.superview).multipliedBy(0.8);
    }];
    [_timeDelineShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_qrInfoImgV);
        make.width.equalTo(_timeDelineShowLabel.superview);
//        make.height.(20);//活动的高度
        make.bottom.equalTo(_timeDelineShowLabel.superview).offset(-30);
    }];
    //
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView.superview).offset(-20-kGHSafeAreaBottomHeight);
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
     
}
#pragma mark ==
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel  = [[UILabel alloc]init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.backgroundColor = Y_ColorWith16FromRGB(0x2672F9);
        _tipLabel.font = [UIFont systemFontOfSize:11];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"温馨提示：用户请将此二维码给予访客，当访客出入门禁时使用";
    }
    return _tipLabel;
}
- (UIView *)qrBackView{
    if (!_qrBackView) {
        _qrBackView = [[UIView alloc]init];
    }
    return _qrBackView;
}
 
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, 90)];
//        [_footerView.footerBtn newAnBtnWithTextStr:@"返回"];//保存二维码
        [_footerView.footerBtn newAnBtnWithTextStr:@"保存二维码"];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:23 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn addTarget:self action:@selector(footerGoBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (UIImageView *)qrInfoImgV{
    if (!_qrInfoImgV) {
        _qrInfoImgV = [[UIImageView alloc]init];
        _qrInfoImgV.contentMode = UIViewContentModeScaleToFill;//
    }
    return _qrInfoImgV;
}
 
- (UILabel *)timeDelineShowLabel{
    if (!_timeDelineShowLabel) {
        _timeDelineShowLabel  = [[UILabel alloc]init];
        _timeDelineShowLabel.textColor = Y_ColorWith16FromRGB(0x999999);
        _timeDelineShowLabel.font = [UIFont boldSystemFontOfSize:12];
        _timeDelineShowLabel.textAlignment = NSTextAlignmentCenter;
        _timeDelineShowLabel.numberOfLines = 0;
    }
    return _timeDelineShowLabel;
}


- (void)footerGoBackBtnAction{
    [self saveThisCodeImgAction];
}
#pragma mark === //截图保存功能
- (void)saveThisCodeImgAction{
    //保存二维码
//    [SaveScreenViewImgToLocalTool saveImgToPhonePhotoLocalWithView:self.view];
    //隐藏保存btn后再存图
    self.footerView.footerBtn.hidden = YES;
    UIView *willUseView = self.view;
    [SaveScreenViewImgToLocalTool saveImgToPhonePhotoLocalWithView:willUseView];
    self.footerView.footerBtn.hidden = NO;
    
}


 
@end
