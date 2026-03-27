//
//  PopViewMoneyTiXianSendPassword.m
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import "PopViewMoneyTiXianSendPassword.h"

@interface PopViewMoneyTiXianSendPassword ()
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) UIButton *deletBtn;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailTitleL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIView *passwordBackView;
@property (nonatomic,strong) TextFieldInfoShowCircleView *passwordCircleView;


@end


@implementation PopViewMoneyTiXianSendPassword

#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
 
    }
    return self;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.99;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 0;
    self.subMainBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];//本view是在底部一半  此view写做为背景
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
     
}
#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.centerBackView];
    [self.centerBackView addSubview:self.deletBtn];
    [self.centerBackView addSubview:self.titleL];
    [self.centerBackView addSubview:self.detailTitleL];
    [self.centerBackView addSubview:self.moneyL];
    [self.centerBackView addSubview:self.passwordBackView];
    //
    [self.passwordBackView addSubview:self.passwordCircleView];
}
- (void)setUI{
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_centerBackView.superview).multipliedBy(0.8);//max_W
        make.height.offset(230);//all_h
        make.centerX.equalTo(_centerBackView.superview);
        make.centerY.equalTo(_centerBackView.superview).offset(-100);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleL.superview);
        make.height.offset(30);
        make.top.equalTo(_titleL.superview).offset(10);
    }];
    [_detailTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_detailTitleL.superview);
        make.height.offset(30);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_moneyL.superview);
        make.height.offset(50);
        make.top.equalTo(_detailTitleL.mas_bottom).offset(5);
    }];
    [_passwordBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyL.mas_bottom).offset(20);
        make.bottom.left.right.equalTo(_passwordBackView.superview);
    }];
    [_passwordCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_centerBackView);///max_W
        make.centerX.centerX.equalTo(_passwordCircleView.superview);
        make.height.offset(60);
    }];
    //
    _passwordBackView.backgroundColor = [UIColor clearColor];
    _passwordCircleView.backgroundColor = [UIColor clearColor];
}

#pragma mark ==
- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    }
    return _centerBackView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:15];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.text = @"请输入支付密码";
    }
    return _titleL;
}
- (UILabel *)detailTitleL{
    if (!_detailTitleL) {
        _detailTitleL = [[UILabel alloc]init];
        _detailTitleL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailTitleL.font = [UIFont systemFontOfSize:16];
        _detailTitleL.textAlignment = NSTextAlignmentCenter;
        _detailTitleL.text = @"提现到";
    }
    return _detailTitleL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont boldSystemFontOfSize:30];
        _moneyL.textAlignment = NSTextAlignmentCenter;
        _moneyL.text = @"0.0";
    }
    return _moneyL;
}
- (UIView *)passwordBackView{
    if (!_passwordBackView) {
        _passwordBackView = [[UIView alloc]init];
        _passwordBackView.backgroundColor = [UIColor clearColor];
    }
    return _passwordBackView;
}
- (TextFieldInfoShowCircleView *)passwordCircleView{
    if (!_passwordCircleView ) {
        _passwordCircleView = [[TextFieldInfoShowCircleView alloc]initWithFrame:CGRectMake(0, 0, Screen_W*0.8, 60)];
    }
    WEAKSELF
    _passwordCircleView.textCircleOkBlock = ^(NSString * textStr) {
     
        [weakSelf sendPassWordStr:textStr];
    };
     return _passwordCircleView;
}
#pragma mark ==
- (void)sendPassWordStr:(NSString *)str{
    DLog(@"");
     
    if (isNil(self.popViewSendPasswordBlock)) {
        return;
    }else{
        self.popViewSendPasswordBlock(str);
    }
}
@end
