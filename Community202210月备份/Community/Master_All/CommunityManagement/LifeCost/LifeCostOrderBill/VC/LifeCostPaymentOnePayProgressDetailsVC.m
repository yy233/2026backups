//
//  LifeCostPaymentOnePayProgressDetailsVC.m
//  Community
//
//  Created by 余莹 on 2021/1/11.
// 本个缴费的 进度 详情

#import "LifeCostPaymentOnePayProgressDetailsVC.h"
#import "LifeCostPaymentOnePayProgressEndCredentialsDetailsVC.h"

#import "LifeCostPaymentOnePayProgressDetailsModel.h"
//
#define Tag_centerView_subBtn   250
#define W_centerView_subBtn     (Screen_W-32)/3
@interface LifeCostPaymentOnePayProgressDetailsVC ()
@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) UIView *bottomBackView;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIButton *moneyBtn;
@property (nonatomic,strong) UILabel *detailShowTypeIsIngLabel;
@property (nonatomic,strong) UILabel *detailShowTypeIsEndLabel;
@property (nonatomic,strong) UIView *progressLineBackView;
//
@property (nonatomic,strong) UIImageView *progressBeginImgV;
@property (nonatomic,strong) UIImageView *progressIngImgV;
@property (nonatomic,strong) UIImageView *progressEndIngImgV;
@property (nonatomic,strong) UILabel *progressBeginLabel;
@property (nonatomic,strong) UILabel *progressIngLabel;
@property (nonatomic,strong) UILabel *progressEndLabel;
@property (nonatomic,strong) UIView *progressBluelineView;
//
@property (nonatomic,strong) UIView *graylineView;
@property (nonatomic,strong) UILabel *bottomAccountTitleL;
@property (nonatomic,strong) UILabel *addressTitleL;
@property (nonatomic,strong) UILabel *bottomAccountConnectL;
@property (nonatomic,strong) UILabel *addressConnectL;

//
@property (nonatomic,assign) PayProgressDetails_Status payStatus;
@end

@implementation LifeCostPaymentOnePayProgressDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费详情";//进度 详情
    [self initView];
    [self initData];
}
- (void)initData{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.orderId) forKey:@"orderId"];
    WEAKSELF
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_Life_PaymentDetails withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                LifeCostPaymentOnePayProgressDetailsModel *model = [LifeCostPaymentOnePayProgressDetailsModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.moneyBtn setTitle:[TextShowWithModelStr textShowWithModelStr:[NSString stringWithFormat:@"-%0.2f",model.paymentBalance]] forState:UIControlStateNormal];
                    [weakSelf.titleBtn setTitle:[TextShowWithModelStr textShowWithModelStr:model.companyName] forState:UIControlStateNormal];
                    weakSelf.addressConnectL.text = [TextShowWithModelStr textShowWithModelStr:model.address];
                    weakSelf.bottomAccountConnectL.text = [TextShowWithModelStr textShowWithModelStr:[NSString stringWithFormat:@"%ld",model.familyId]];
                    weakSelf.payStatus = model.status;
                    [self setProcessViewType];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)centerSubBtnAction:(UIButton *)sender{
    switch (sender.tag-Tag_centerView_subBtn) {
        case 0:
            NSLog(@"历史缴费");
            break;
        case 1:
            NSLog(@"自动缴费");
            break;
        case 2:
        {
            NSLog(@"缴费凭证");
            LifeCostPaymentOnePayProgressEndCredentialsDetailsVC *vc = [[LifeCostPaymentOnePayProgressEndCredentialsDetailsVC alloc]init];
            vc.orderId = self.orderId;
            [self pushVc:vc];
        }
            
            break;
            
        default:
            break;
    }
}
#pragma mark ==
- (void)setProcessViewType{
    switch (self.payStatus) {
        case PayProgressDetails_Status_Begin:
        {
            self.progressBeginImgV.image = [UIImage imageNamed:@"Paymentdetails_Processing_night"];
            self.detailShowTypeIsIngLabel.hidden = YES;
            self.detailShowTypeIsEndLabel.hidden = YES;
        }
            break;
        case PayProgressDetails_Status_Processing:
        {
            self.progressBeginImgV.image = [UIImage imageNamed:@"Paymentdetails_Success_night"];
            self.progressIngImgV.image = [UIImage imageNamed:@"Paymentdetails_Processing_night"];
            self.detailShowTypeIsIngLabel.hidden = NO;
            self.detailShowTypeIsEndLabel.hidden = YES;
        }
            break;
        case PayProgressDetails_Status_Success:
        {
            self.progressBeginImgV.image = [UIImage imageNamed:@"Paymentdetails_Success_night"];
            self.progressIngImgV.image = [UIImage imageNamed:@"Paymentdetails_Success_night"];
            self.progressEndIngImgV.image = [UIImage imageNamed:@"Paymentdetails_Success_night"];
            self.detailShowTypeIsIngLabel.hidden = YES;
            self.detailShowTypeIsEndLabel.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}
#pragma mark ==
- (void)initView{
    [self.view addSubview:self.topBackView];
    [self.view addSubview:self.centerBackView];
    [self.view addSubview:self.bottomBackView];
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.superview.mas_top).offset(20);
        make.left.equalTo(_topBackView.superview.mas_left).offset(16);
        make.right.equalTo(_topBackView.superview.mas_right).offset(-16);
        make.height.equalTo(_topBackView.superview.mas_height).multipliedBy(0.5);
    }];
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.mas_bottom).offset(20);
        make.left.equalTo(_centerBackView.superview.mas_left).offset(16);
        make.right.equalTo(_centerBackView.superview.mas_right).offset(-16);
        make.height.offset(50);
    }];
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBackView.superview.mas_bottom).offset(-20);
        make.left.equalTo(_bottomBackView.superview.mas_left).offset(16);
        make.right.equalTo(_bottomBackView.superview.mas_right).offset(-16);
        make.height.offset(80);
    }];
    [self topAllRadius];
    [self addTopSubView];
    [self addCenterSubView];
}
- (void)addTopSubView{
    [self.topBackView addSubview:self.titleBtn];
    [self.topBackView addSubview:self.moneyBtn];
    [self.topBackView addSubview:self.detailShowTypeIsIngLabel];
    [self.topBackView addSubview:self.detailShowTypeIsEndLabel];
    [self.topBackView addSubview:self.progressLineBackView];//进度线的背景view
    //
    [self.progressLineBackView addSubview:self.progressBeginLabel];
    [self.progressLineBackView addSubview:self.progressIngLabel];
    [self.progressLineBackView addSubview:self.progressEndLabel];
    //
    [self.progressLineBackView addSubview:self.progressBluelineView];
    [self.progressLineBackView addSubview:self.progressBeginImgV];
    [self.progressLineBackView addSubview:self.progressIngImgV];
    [self.progressLineBackView addSubview:self.progressEndIngImgV];
    //
    [self.topBackView addSubview:self.graylineView];
    [self.topBackView addSubview:self.bottomAccountTitleL];
    [self.topBackView addSubview:self.bottomAccountConnectL];
    [self.topBackView addSubview:self.addressTitleL];
    [self.topBackView addSubview:self.addressConnectL];
    
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleBtn.superview.mas_top).offset(20);
        make.left.equalTo(_titleBtn.superview.mas_left).offset(10);
        make.right.equalTo(_titleBtn.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleBtn.mas_bottom).offset(10);
        make.left.equalTo(_moneyBtn.superview.mas_left).offset(10);
        make.right.equalTo(_moneyBtn.superview.mas_right).offset(-10);
        make.height.offset(30);
    }];
    //
    [_detailShowTypeIsIngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyBtn.mas_bottom).offset(10);
        make.centerX.equalTo(_detailShowTypeIsIngLabel.superview.mas_centerX);
        make.height.offset(30);
    }];
    [_detailShowTypeIsEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyBtn.mas_bottom).offset(10);
        make.centerX.equalTo(_detailShowTypeIsEndLabel.superview.mas_centerX).multipliedBy(1.67);
        make.height.offset(30);
    }];
    //
    [_progressLineBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailShowTypeIsIngLabel.mas_bottom).offset(5);
        make.left.equalTo(_progressLineBackView.superview.mas_left).offset(0);
        make.right.equalTo(_progressLineBackView.superview.mas_right).offset(0);
        make.height.offset(80);
    }];
    [_progressBeginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressLineBackView.mas_top).offset(20);////////
        make.left.equalTo(_progressLineBackView.mas_left).offset(0);
        make.width.offset((Screen_W-32)/3);
        make.height.offset(20);
    }];
    [_progressIngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressBeginLabel.mas_top);
        make.left.equalTo(_progressBeginLabel.mas_right).offset(0);
        make.width.offset((Screen_W-32)/3);
        make.height.offset(20);
    }];
    [_progressEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressIngLabel.mas_top);
        make.left.equalTo(_progressIngLabel.mas_right).offset(0);
        make.width.offset((Screen_W-32)/3);
        make.height.offset(20);
    }];
   
    //
    [_progressBeginImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.centerX.equalTo(_progressBeginLabel);
        make.bottom.equalTo(_progressBeginLabel.mas_top).offset(0);
    }];
    [_progressIngImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.centerX.equalTo(_progressIngLabel);
        make.bottom.equalTo(_progressIngLabel.mas_top).offset(0);
    }];
    [_progressEndIngImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.centerX.equalTo(_progressEndLabel);
        make.bottom.equalTo(_progressEndLabel.mas_top).offset(0);
    }];
    //
    [_progressBluelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressBeginImgV.mas_right);
        make.right.equalTo(_progressEndIngImgV.mas_left);
        make.height.offset(1.2);
        make.centerY.equalTo(_progressBeginImgV.mas_centerY);
    }];
    //
    [_graylineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressLineBackView.mas_bottom).offset(5);
        make.left.equalTo(_graylineView.superview.mas_left).offset(10);
        make.right.equalTo(_graylineView.superview.mas_right).offset(-10);
        make.height.offset(1);
    }];
    [_bottomAccountTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_graylineView.mas_bottom).offset(10);
        make.left.equalTo(_graylineView.superview.mas_left).offset(10);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_bottomAccountConnectL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomAccountTitleL.mas_centerY);
        make.left.equalTo(_bottomAccountTitleL.mas_right);
        make.right.equalTo(_bottomAccountConnectL.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_addressTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomAccountTitleL.mas_bottom).offset(10);
        make.left.equalTo(_bottomAccountTitleL.mas_left);
        make.right.equalTo(_bottomAccountTitleL.mas_right);
        make.height.equalTo(_bottomAccountTitleL.mas_height);
    }];
    [_addressConnectL mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(_addressTitleL.mas_centerY);
        make.left.equalTo(_addressTitleL.mas_right);
        make.right.equalTo(_addressConnectL.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
}
- (void)addCenterSubView{
    for (int i = 0 ; i <3; i++) {
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [subBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        subBtn.tag = Tag_centerView_subBtn+i;
        [subBtn addTarget:self action:@selector(centerSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        subBtn.frame = CGRectMake( W_centerView_subBtn*i, 15, W_centerView_subBtn-1, 20);
        if (i==0) {
            [subBtn setTitle:@"历史缴费" forState:UIControlStateNormal];
        }else if (i==1){
            [subBtn setTitle:@"自动缴费" forState:UIControlStateNormal];
        }else{
            [subBtn setTitle:@"缴费凭证" forState:UIControlStateNormal];
        }
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];
        lineV.frame = CGRectMake( W_centerView_subBtn*(i+1), 15, 1, 20);
        [self.centerBackView addSubview:lineV];
        [self.centerBackView addSubview:subBtn];
    }
}

#pragma mark ===
- (void)topAllRadius{
    CGRect topBackViewBounds = CGRectMake(0, 0, self.view.frame.size.width-32, (Screen_H-KNavBarHeight)*0.5);
    NSInteger cornerR = 10;
    for (int i = 0; i <4; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        if (i==0) {
            imageView.frame = CGRectMake(-cornerR, -cornerR, 2*cornerR, 2*cornerR);
        }else if (i==1){
            imageView.frame = CGRectMake(-cornerR, CGRectGetMaxY(topBackViewBounds)-cornerR, 2*cornerR, 2*cornerR);
        }else if (i==2){
            imageView.frame = CGRectMake(CGRectGetMaxX(topBackViewBounds)-cornerR, CGRectGetMaxY(topBackViewBounds)-cornerR, 2*cornerR, 2*cornerR);
        }else{
            imageView.frame = CGRectMake(CGRectGetMaxX(topBackViewBounds)-cornerR, -cornerR, 2*cornerR, 2*cornerR);
        }
        imageView.image = [UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = imageView.bounds;
        maskLayer.path = maskPath.CGPath;
        imageView.layer.mask = maskLayer;
        [self.topBackView addSubview:imageView];
    }
}
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
        _topBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _topBackView;
}
- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.layer.cornerRadius = 10;
        _centerBackView.layer.masksToBounds = YES;
        _centerBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _centerBackView;
}
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
        _bottomBackView.backgroundColor = [UIColor lightGrayColor];
        _bottomBackView.layer.cornerRadius = 10;
        _bottomBackView.layer.masksToBounds = YES;
    }
    return _bottomBackView;
}
#pragma mark ==

- (UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_titleBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    }
    return _titleBtn;
}
- (UIButton *)moneyBtn{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [_moneyBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    }
    return _moneyBtn;
}
- (UILabel *)detailShowTypeIsIngLabel{
    if (!_detailShowTypeIsIngLabel) {
        _detailShowTypeIsIngLabel = [[UILabel alloc]init];
        _detailShowTypeIsIngLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailShowTypeIsIngLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _detailShowTypeIsIngLabel.text = @"机构正在处理，请耐心等待";
        _detailShowTypeIsIngLabel.backgroundColor = Y_RGBA(38, 114, 249, 0.2);//透明度
        _detailShowTypeIsIngLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailShowTypeIsIngLabel;
}
- (UILabel *)detailShowTypeIsEndLabel{
    if (!_detailShowTypeIsEndLabel) {
        _detailShowTypeIsEndLabel = [[UILabel alloc]init];
        _detailShowTypeIsEndLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailShowTypeIsEndLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _detailShowTypeIsEndLabel.text = @"已到账";
        _detailShowTypeIsEndLabel.backgroundColor = Y_RGBA(38, 114, 249, 0.2);//透明度
        _detailShowTypeIsEndLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailShowTypeIsEndLabel;
}
 
#pragma mark ===
- (UIView *)progressLineBackView{
    if (!_progressLineBackView) {
        _progressLineBackView = [[UIView alloc]init];
    }
    return _progressLineBackView;
}
- (UILabel *)progressBeginLabel{
    if (!_progressBeginLabel) {
        _progressBeginLabel = [[UILabel alloc]init];
        _progressBeginLabel.font = [UIFont boldSystemFontOfSize:10];
        _progressBeginLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _progressBeginLabel.text = @"支付成功";
        _progressBeginLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressBeginLabel;
}
- (UILabel *)progressIngLabel{
    if (!_progressIngLabel) {
        _progressIngLabel = [[UILabel alloc]init];
        _progressIngLabel.font = [UIFont boldSystemFontOfSize:10];
        _progressIngLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _progressIngLabel.text = @"机构处理";
        _progressIngLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressIngLabel;
}
- (UILabel *)progressEndLabel{
    if (!_progressEndLabel) {
        _progressEndLabel = [[UILabel alloc]init];
        _progressEndLabel.font = [UIFont boldSystemFontOfSize:10];
        _progressEndLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _progressEndLabel.text = @"支付成功";
        _progressEndLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressEndLabel;
  
}
//
- (UIView *)progressBluelineView{
    if (!_progressBluelineView) {
        _progressBluelineView = [[UIView alloc]init];
        _progressBluelineView.backgroundColor = Color_38BlueColor;
    }
    return _progressBluelineView;
}
//
- (UIImageView *)progressBeginImgV{
    if (!_progressBeginImgV) {
        _progressBeginImgV = [[UIImageView alloc]init];
        _progressBeginImgV.backgroundColor = Color_38BlueColor;
        _progressBeginImgV.contentMode = UIViewContentModeCenter;
//        _progressBeginImgV.layer.cornerRadius = 8;
//        _progressBeginLabel.layer.masksToBounds = YES;
        [_progressBeginImgV zy_cornerRadiusAdvance:8 rectCornerType:UIRectCornerAllCorners];
    }
    return _progressBeginImgV;
}
- (UIImageView *)progressIngImgV{
    if (!_progressIngImgV) {
        _progressIngImgV = [[UIImageView alloc]init];
        _progressIngImgV.backgroundColor = Color_38BlueColor;
        _progressIngImgV.contentMode = UIViewContentModeCenter;
//        _progressIngImgV.layer.cornerRadius = 8;
//        _progressIngImgV.layer.masksToBounds = YES;
        [_progressIngImgV zy_cornerRadiusAdvance:8 rectCornerType:UIRectCornerAllCorners];
    }
    return _progressIngImgV;
}
- (UIImageView *)progressEndIngImgV{
    if (!_progressEndIngImgV) {
        _progressEndIngImgV = [[UIImageView alloc]init];
        _progressEndIngImgV.backgroundColor = Color_38BlueColor;
        _progressEndIngImgV.contentMode = UIViewContentModeCenter;
//        _progressEndIngImgV.layer.cornerRadius = 8;
//        _progressEndIngImgV.layer.masksToBounds = YES;
        [_progressEndIngImgV zy_cornerRadiusAdvance:8 rectCornerType:UIRectCornerAllCorners];
    }
    return _progressEndIngImgV;
}


- (UIView *)graylineView{
    if (!_graylineView) {
        _graylineView = [[UIView alloc]init];
        _graylineView.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];
    }
    return _graylineView;
}
 
#pragma mark ===
- (UILabel *)bottomAccountTitleL{
    if (!_bottomAccountTitleL) {
        _bottomAccountTitleL = [[UILabel alloc]init];
        _bottomAccountTitleL.font = [UIFont boldSystemFontOfSize:10];
        _bottomAccountTitleL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _bottomAccountTitleL.text = @"账号信息";
    }
    return _bottomAccountTitleL;
}
- (UILabel *)bottomAccountConnectL{
    if (!_bottomAccountConnectL) {
        _bottomAccountConnectL = [[UILabel alloc]init];
        _bottomAccountConnectL.font = [UIFont boldSystemFontOfSize:10];
        _bottomAccountConnectL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
//        _bottomAccountConnectL.text = @"xxxxxz账号xxx";
        _bottomAccountConnectL.textAlignment = NSTextAlignmentRight;
    }
    return _bottomAccountConnectL;
}
- (UILabel *)addressTitleL{
    if (!_addressTitleL) {
        _addressTitleL = [[UILabel alloc]init];
        _addressTitleL.font = [UIFont boldSystemFontOfSize:10];
        _addressTitleL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _addressTitleL.text = @"住址信息";
    }
    return _addressTitleL;
}
- (UILabel *)addressConnectL{
    if (!_addressConnectL) {
        _addressConnectL = [[UILabel alloc]init];
        _addressConnectL.font = [UIFont boldSystemFontOfSize:10];
        _addressConnectL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
//        _addressConnectL.text = @"xx小区xx栋xxx号";
        _addressConnectL.textAlignment = NSTextAlignmentRight;
    }
    return _addressConnectL;
}
@end
