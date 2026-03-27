//
//  LifeCostWillPayBaseDetailHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostWillPayBaseDetailMainTopView.h"
#import "PayOrderDetailAllTypeHeader.h"

@interface LifeCostWillPayBaseDetailMainTopView ()

@property (nonatomic,assign) CGSize saveSekfViewSize;

@end
@implementation LifeCostWillPayBaseDetailMainTopView

- (void)fillTopViewDataWithImgUrlStr:(NSString *)imgUrlStr withMoneyNumStr:(NSString *)moneyNumStr{
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgUrlStr] placeholderImage:[UIImage imageNamed:kLifeCost_Placeholder_NotBackColor_ImgName]];
    self.moneyNumL.text = moneyNumStr;
 
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self.saveSekfViewSize = frame.size;
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImgV];
        [self addSubview:self.contentSubVBackView];
        [self addSubview:self.shadowView];
        [self.shadowView addSubview:self.imgV];
        
        [self.contentSubVBackView addSubview:self.moneySignL];
        [self.contentSubVBackView addSubview:self.moneyNumL];
        [self.contentSubVBackView addSubview:self.bottomL];
        [self.contentSubVBackView addSubview:self.lineV];
        [self setUI];
        [self setSubViewColor];
    }
    return self;
}
- (void)setUI{

    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgImgV.superview);
    }];
    [_contentSubVBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentSubVBackView.superview).offset(16);
        make.right.equalTo(_contentSubVBackView.superview).offset(-16);
        make.bottom.equalTo(_contentSubVBackView.superview);
        make.top.equalTo(_contentSubVBackView.superview).offset(38);
    }];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_shadowView.superview);
        make.width.height.offset(55.0);
        make.top.equalTo(_contentSubVBackView.mas_top).offset(-27.5);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_shadowView);
    }];
    [_moneyNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgV.superview);
        make.height.offset(30.0);
        make.top.equalTo(_imgV.mas_bottom).offset(15);
    }];
    [_moneySignL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_moneyNumL);
        make.width.offset(30);
        make.right.equalTo(_moneyNumL.mas_left);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomL.superview);
        make.height.offset(20);
        make.top.equalTo(_moneySignL.mas_bottom).offset(5);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentSubVBackView).offset(10);
        make.right.equalTo(_contentSubVBackView).offset(-10);
        make.height.offset(1.0);
        make.top.equalTo(_bottomL.mas_bottom).offset(15);
    }];
    
}
- (void)setSubViewColor{
    //总背景img
    UIColor *endColor =  [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    if ([ThemeManager shareManager].type == ThemeType_White) {//bgimg渐变
        UIColor * beginColor = Nav_BrightBlueColor;
//        self.bgImgV
        CGSize size = CGSizeMake(self.saveSekfViewSize.width, self.saveSekfViewSize.height+3);//相同时会有边界线
        self.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
    }else{//深色——深色(一个色 不渐变)
        self.backgroundColor = endColor;
    }
    //中心viewBk
    self.contentSubVBackView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.contentSubVBackView.layer.cornerRadius = 5.0;
    self.contentSubVBackView.layer.masksToBounds = YES;
}
#pragma mark ==
- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc]init];
    }
    return _bgImgV;
}
- (UIView *)contentSubVBackView{
    if (!_contentSubVBackView) {
        _contentSubVBackView = [[UIView alloc]init];
    }
    return _contentSubVBackView;
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
- (UILabel *)moneySignL{
    if (!_moneySignL) {
        _moneySignL = [[UILabel alloc]init];
        _moneySignL.font = [UIFont boldSystemFontOfSize:30.0];
        _moneySignL.text = @"¥";
        _moneySignL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _moneySignL;
}
- (UILabel *)moneyNumL{
    if (!_moneyNumL) {
        _moneyNumL = [[UILabel alloc]init];
        _moneyNumL.font = [UIFont boldSystemFontOfSize:30.0];
        _moneyNumL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyNumL.textAlignment = NSTextAlignmentLeft;
        _moneyNumL.text = @"0";
    }
    return _moneyNumL;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.font = [UIFont systemFontOfSize:15];
        _bottomL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.text = @"应缴金额（元）";
    }
    return _bottomL;
}
- (UILabel *)lineV{
    if (!_lineV) {
        _lineV = [[UILabel alloc]init];
        _lineV.backgroundColor = [[ThemeManager shareManager].themeLineColor colorWithAlphaComponent:0.2];
    }
    return _lineV;
}
@end
