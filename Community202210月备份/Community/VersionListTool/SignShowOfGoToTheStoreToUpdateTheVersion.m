//
//  SignShowOfGoToTheStoreToUpdateTheVersion.m
//  Community
//
//  Created by 余莹 on 2022/4/9.
// 强制升级状态下 的 提示view

#import "SignShowOfGoToTheStoreToUpdateTheVersion.h"

static NSString *kTextViewDefault = @"用户您好：\n        当前版本过低，建议您去商店更新版本。";
static NSString *kSelfAppStoreURL = @"itms-apps://itunes.apple.com/cn/app/id1559148512";

@interface SignShowOfGoToTheStoreToUpdateTheVersion ()
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) UIView *backCenterGroundView;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *bottomBtn;
@property (nonatomic,strong) UIButton *goToStroeBtn;
@end

@implementation SignShowOfGoToTheStoreToUpdateTheVersion

- (void)fillInfoOfStr:(NSString *)showStr{
    if (showStr.length>0) {
        [self textViewInitShowStr:showStr];
    }
}
- (UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]init];
        _backImgV.contentMode = UIViewContentModeScaleAspectFill;
        _backImgV.image = [UIImage imageNamed:@"weiguitanchuang"];
    }
    return _backImgV;
}
- (UIView *)backCenterGroundView{
    if (!_backCenterGroundView) {
        _backCenterGroundView = [[UIView alloc]init];
    }
    return _backCenterGroundView;
}
//
- (UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn newAnBtnWithImg:[UIImage imageNamed:@"tongzhi"]];
    }
    return _titleBtn;
}
- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn newAnBtnWithTextStr:@"我已悉知"];
        [_bottomBtn newAnBtnWithTextColor: [UIColor whiteColor]];
        [_bottomBtn newAnBtnWithFont: [UIFont systemFontOfSize:15.0]];
        [_bottomBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xA33021)];
        [_bottomBtn newAnBtnWithLayerCorNerNum:14.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
 
- (UIButton *)goToStroeBtn{
    if (!_goToStroeBtn) {
        _goToStroeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goToStroeBtn newAnBtnWithTextStr:@"去往商店"];
        [_goToStroeBtn newAnBtnWithTextColor: [UIColor whiteColor]];
        [_goToStroeBtn newAnBtnWithFont: [UIFont systemFontOfSize:15.0]];
        [_goToStroeBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xA33021)];
        [_goToStroeBtn newAnBtnWithLayerCorNerNum:14.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_goToStroeBtn addTarget:self action:@selector(gotoStroeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goToStroeBtn;
}

- (void)bottomBtnAction{//删除本视图
    [self removeFromSuperview];
}
- (void)gotoStroeBtnAction{
    NSURL *appUrl = [NSURL URLWithString:kSelfAppStoreURL];
    if([[UIApplication sharedApplication] canOpenURL:appUrl])
    {
        [[UIApplication sharedApplication] openURL:appUrl];
    }
    else
    {
        Y_SVP_SHOW_ERR_MES(@"无法打开 AppStore，请稍后再试。");
    }
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = Y_ColorWith16FromRGB(0x59231B);
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

- (void)textViewInitShowStr:(NSString *)showStr{
  
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0x59231B)
                                 };
    if (showStr.length<=0) {
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:kTextViewDefault attributes:attributes];
    }else{
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:[kTextViewDefault stringByAppendingFormat:@"\n        最新版本更新信息如下:\n        %@",showStr] attributes:attributes];

    }
}

 

#pragma mark ==
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.backImgV];
        [self addSubview:self.backCenterGroundView];
        [self bkViewAddViews];
        [self setBaseUI];
        [self textViewInitShowStr:@""];//文本赋值
    }
    return self;
}
 
- (void)bkViewAddViews{
    [self.backCenterGroundView addSubview:self.titleBtn];
    [self.backCenterGroundView addSubview:self.bottomBtn];
    [self.backCenterGroundView addSubview:self.goToStroeBtn];
    [self.backCenterGroundView addSubview:self.textView];
}
- (void)setBaseUI{
    //
    [_backCenterGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_backImgV.superview);
        make.width.equalTo(_backImgV.superview).offset(-20.0);
        make.height.equalTo(_backImgV.mas_width).multipliedBy(1.3);//宽高比
    }];
    [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backCenterGroundView);
    }];
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60.0);
        make.height.offset(30);
        make.centerX.equalTo(_titleBtn.superview);
        make.top.equalTo(_titleBtn.superview).offset(30);
    }];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100.0);
        make.height.offset(30);
        //make.centerX.equalTo(_bottomBtn.superview).offset(-50-10);//中心位置向左10
        make.right.equalTo(_bottomBtn.superview.mas_centerX).offset(-10);
        make.bottom.equalTo(_bottomBtn.superview).offset(-40);
    }];
    [_goToStroeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100.0);
        make.height.offset(30);
        //make.centerX.equalTo(_bottomBtn.superview).offset(50+10);//中心位置 向右10
        make.left.equalTo(_bottomBtn.superview.mas_centerX).offset(10);

        make.bottom.equalTo(_bottomBtn.superview).offset(-40);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_textView.superview);
        make.width.equalTo(_textView.superview).offset(-60);
        make.height.equalTo(_textView.mas_width);
        make.top.equalTo(_titleBtn.mas_bottom).offset(20);
    }];
    
}

@end
