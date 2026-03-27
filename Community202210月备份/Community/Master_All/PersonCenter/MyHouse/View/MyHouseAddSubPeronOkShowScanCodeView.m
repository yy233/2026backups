//
//  MyHouseAddSubPeronOkShowScanCodeView.m
//  Community
//
//  Created by 余莹 on 2021/10/16.
//

#import "MyHouseAddSubPeronOkShowScanCodeView.h"

@implementation MyHouseAddSubPeronOkShowScanCodeView
/**
 
 @property (nonatomic,strong) UIImageView *headerImg;
 @property (nonatomic,strong) UILabel *topLabel;
 @property (nonatomic,strong) UILabel *topDetailLabel;
 @property (nonatomic,strong) UILabel *scanBottomHouseInfoDetailLabel;
 @property (nonatomic,strong) UIButton *bottomScanBtn;
 @property (nonatomic,strong) UIButton *bottomHeadBtn;
 @property (nonatomic,strong) UIButton *savePhoneBtn;
 @property (nonatomic,strong) UIImageView *scanCodeImg;
 */
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headerImg];
        [self addSubview:self.topLabel];
        [self addSubview:self.topDetailLabel];
        //
        [self addSubview:self.bottomScanBtn];
        [self addSubview:self.bottomHeadBtn];
        [self addSubview:self.savePhoneBtnView];
        //
        [self addSubview:self.scanCodeImgBackV];
        [self.scanCodeImgBackV addSubview:self.scanCodeImg];
        [self.scanCodeImgBackV addSubview:self.scanBottomHouseInfoDetailLabel];
        self.scanCodeImg.backgroundColor = [UIColor cyanColor];
        [self setUI];
        
    }
    return self;
}
#pragma mark ==
- (void)setUI{
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerImg.superview);
        make.width.height.offset(70);
        make.top.equalTo(_headerImg.superview).offset(15);
    }];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerImg.superview);
        make.width.equalTo(_headerImg.superview);
        make.height.offset(20);
        make.top.equalTo(_headerImg.mas_bottom).offset(10);
    }];
    [_topDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(_topLabel);
        make.top.equalTo(_topLabel.mas_bottom).offset(10);
    }];
    //
    [_savePhoneBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_savePhoneBtnView.superview);
        make.height.offset(90);
        make.centerX.equalTo(_savePhoneBtnView.superview);
        make.bottom.equalTo(_savePhoneBtnView.superview);
    }];
    [_bottomScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_bottomScanBtn.superview).multipliedBy(0.5);
        make.right.equalTo(_bottomScanBtn.superview.mas_centerX);
        make.left.equalTo(_bottomScanBtn.superview.mas_left);
        make.bottom.equalTo(_savePhoneBtnView.mas_top);
        make.height.offset(50);
    }];
    [_bottomHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_bottomScanBtn);
        make.left.equalTo(_bottomScanBtn.mas_right);
        make.right.equalTo(_bottomScanBtn.superview.mas_right);
        make.bottom.equalTo(_bottomScanBtn);
        make.height.offset(50);

    }];
 
    //
    [_scanCodeImgBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topDetailLabel.mas_bottom).offset(0);
        make.bottom.equalTo(_bottomScanBtn.mas_top).offset(0);
        make.centerX.equalTo(_scanCodeImg.superview);
        make.width.equalTo(_scanCodeImgBackV.superview);
    }];
    [_scanCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(_scanCodeImg.superview);
        make.width.equalTo(_scanCodeImg.superview).multipliedBy(0.7);
        make.height.equalTo(_scanCodeImg.mas_width);
    }];
    [_scanBottomHouseInfoDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scanCodeImg.mas_bottom).offset(1);
        make.left.right.equalTo(_scanBottomHouseInfoDetailLabel.superview);
        make.height.offset(20);
    }];
    
}
#pragma mark ==
- (UIImageView *)headerImg{
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc]init];
    }
    return _headerImg;
}
- (UIImageView *)scanCodeImg{
    if (!_scanCodeImg) {
        _scanCodeImg = [[UIImageView alloc]init];
    }
    return _scanCodeImg;
}
- (UIView *)scanCodeImgBackV{
    if (!_scanCodeImgBackV) {
        _scanCodeImgBackV = [[UIView alloc]init];
    }
    return _scanCodeImgBackV;
}
//
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor = Color_51BlackColor;
        _topLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _topLabel;
}
- (UILabel *)topDetailLabel{
    if (!_topDetailLabel) {
        _topDetailLabel = [[UILabel alloc]init];
        _topDetailLabel.textAlignment = NSTextAlignmentCenter;
        _topDetailLabel.textColor = [Color_51BlackColor colorWithAlphaComponent:0.7];
        _topDetailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _topDetailLabel;
}
- (UILabel *)scanBottomHouseInfoDetailLabel{
    if (!_scanBottomHouseInfoDetailLabel) {
        _scanBottomHouseInfoDetailLabel = [[UILabel alloc]init];
        _scanBottomHouseInfoDetailLabel.textAlignment = NSTextAlignmentCenter;
        _scanBottomHouseInfoDetailLabel.textColor = [Color_51BlackColor colorWithAlphaComponent:0.7];
        _scanBottomHouseInfoDetailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _scanBottomHouseInfoDetailLabel;
}
//
- (BaseTableViewFooterView *)savePhoneBtnView{
    if (!_savePhoneBtnView) {
        _savePhoneBtnView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32-40, 90)];
        [_savePhoneBtnView.footerBtn newAnBtnWithTextStr:@"保存到手机"];
    }
    return _savePhoneBtnView;
}
- (UIButton *)bottomHeadBtn{
    if (!_bottomHeadBtn) {
        _bottomHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomHeadBtn newAnBtnWithTextStr:@"用未来物服APP，扫描二维码"];
        [_bottomHeadBtn newAnBtnWithTextColor:[Color_51BlackColor colorWithAlphaComponent:0.7]];
        [_bottomHeadBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_bottomHeadBtn newAnBtnWithImg:[UIImage imageNamed:@"houseAddPersonScan"]];
        [_bottomHeadBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _bottomHeadBtn;
}
- (UIButton *)bottomScanBtn{
    if (!_bottomScanBtn) {
        _bottomScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomScanBtn newAnBtnWithTextStr:@"确认无误后，扫码绑定"];
        [_bottomScanBtn newAnBtnWithTextColor:[Color_51BlackColor colorWithAlphaComponent:0.7]];
        [_bottomScanBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_bottomScanBtn newAnBtnWithImg:[UIImage imageNamed:@"bindrole"]];
        [_bottomScanBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _bottomScanBtn;
}
#pragma mark ==

- (void)addPersonOkUrlIs:(NSString *)urlStr{
    DLog(@"生成二维码");
    CGFloat w = (Screen_W-40)*0.7;
    CGFloat h = w;
 
    UIImage *QRImage = [LBXScanWrapper createQRWithString:urlStr size: CGSizeMake(w, h)]; //self.scanCodeImg.bounds.size];
    self.scanCodeImg.image = QRImage;
 }
@end
