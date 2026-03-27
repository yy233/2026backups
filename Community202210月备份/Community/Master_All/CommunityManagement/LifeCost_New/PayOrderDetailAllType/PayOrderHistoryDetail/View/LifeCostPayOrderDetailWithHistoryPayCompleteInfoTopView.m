//
//  LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView.h"
#import "PayOrderDetailAllTypeHeader.h"
@implementation LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView
- (void)fillTopViewDataWithImgUrlStr:(NSString *)imgUrlStr withMoneyNumStr:(NSString *)moneyNumStr{
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgUrlStr] placeholderImage:[UIImage imageNamed:kLifeCost_Placeholder_NotBackColor_ImgName]];
    self.moneyNumL.text = moneyNumStr;
 
}
- (instancetype)initWithFrame:(CGRect)frame
{//总165 tableview遮住45 剩125可见
    self = [super initWithFrame:frame];
    if (self) {
        if ([ThemeManager shareManager].type == ThemeType_White) {
            self.backgroundColor = PayOrder_BrightBlueColor;
        }else{
            self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        }
        [self addSubview:self.shadowView];
        [self.shadowView addSubview:self.imgV];
        [self addSubview:self.moneySignL];
        [self addSubview:self.moneyNumL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_shadowView.superview);
        make.top.equalTo(_shadowView.superview).offset(10);
        make.width.height.offset(55.0);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_shadowView);
    }];
    [_moneyNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgV.superview);
        make.height.offset(25.0);
        make.top.equalTo(_imgV.mas_bottom).offset(10);
    }];
    [_moneySignL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_moneyNumL);
        make.width.offset(20);
        make.right.equalTo(_moneyNumL.mas_left);
    }];
}
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]init];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.cornerRadius = 27.0;
        _shadowView.layer.masksToBounds = NO;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 1);
        _shadowView.layer.shadowOpacity = 0.8;
        _shadowView.layer.shadowRadius = 3.f;
    }
    return _shadowView;
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeCenter;
        _imgV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _imgV.layer.cornerRadius = 27.0;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}
- (UILabel *)moneySignL{
    if (!_moneySignL) {
        _moneySignL = [[UILabel alloc]init];
        _moneySignL.font = [UIFont boldSystemFontOfSize:30.0];
        _moneySignL.text = @"¥";
        _moneySignL.textColor = [UIColor whiteColor];
    }
    return _moneySignL;
}
- (UILabel *)moneyNumL{
    if (!_moneyNumL) {
        _moneyNumL = [[UILabel alloc]init];
        _moneyNumL.font = [UIFont boldSystemFontOfSize:30.0];
        _moneyNumL.textColor = [UIColor whiteColor];
        _moneyNumL.textAlignment = NSTextAlignmentLeft;
    }
    return _moneyNumL;
}
@end
