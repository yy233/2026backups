//
//  BaseTableViewFooterView.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "BaseTableViewFooterView.h"
#define Btn_H 44
#define BackView_H 90
@interface BaseTableViewFooterView ()
//@property (nonatomic,strong) UIView *footerBackview;
@property (nonatomic,assign) float view_h;
@property (nonatomic,assign) float view_w;
@end

@implementation BaseTableViewFooterView
- (void)setBtnFramWithNotCenterxIsCenteryOfMasWithFram:(CGRect)fram{//xy w h
    self.footerBtn.frame = fram;
    [_footerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_footerBtn.superview.mas_centerY);
//        make.top.offset(fram.origin.y);
        make.left.offset(fram.origin.x);
        make.width.offset(fram.size.width);
        make.height.offset(fram.size.height);
    }];
}
- (void)setBtnFram:(CGRect)fram{
    self.footerBtn.frame = fram;
    [_footerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerBtn.superview.mas_centerX);
        make.centerY.equalTo(_footerBtn.superview.mas_centerY);
        make.width.offset(fram.size.width);
        make.height.offset(fram.size.height);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.view_h = frame.size.height;
    self.view_w = frame.size.width;
    if (self) {
        [self addSubview:self.footerBackview];
        [self.footerBackview addSubview:self.footerBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_footerBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_footerBackview.superview);//clearcolor
    }];
    [_footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerBtn.superview.mas_centerX);
        make.centerY.equalTo(_footerBtn.superview.mas_centerY);
//        make.width.equalTo(_footerBtn.superview.mas_width).offset(-32);
        make.width.offset(_view_w);
        make.height.equalTo(_footerBtn.superview.mas_height).offset(Btn_H-_view_h);
    }];
    
}

- (UIView *)footerBackview{
    if (!_footerBackview) {
        _footerBackview = [[UIView alloc]init];
        _footerBackview.backgroundColor = [UIColor clearColor];
        [_footerBackview addSubview:self.footerBtn];
    }
    return _footerBackview;
}
- (UIButton *)footerBtn{
    if (!_footerBtn) {
        _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_footerBtn setTitle:@"+ basefooterBtn +" forState:UIControlStateNormal];
        [_footerBtn setTitle:@"" forState:UIControlStateNormal];
        [_footerBtn addTarget:self.superview action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _footerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_footerBtn setBackgroundColor:Y_RGBA(38, 114, 249, 1)];
            [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [_footerBtn setBackgroundColor:Y_RGBA(17, 41, 87, 1)];
            [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        _footerBtn.layer.cornerRadius = 5;
        _footerBtn.layer.masksToBounds = YES;
    }
    _footerBtn.backgroundColor = [UIColor colorWithRed:38/255.0 green:114/255.0 blue:249/255.0 alpha:1.0];
     return _footerBtn;
}
//视图总宽高  frame = CGRectMake(0, 0, Screen_W, BackView_H);
- (float)view_h{
    if (!_view_h) {
        _view_h = BackView_H;
    }
    return _view_h;
}
- (float)view_w{
    if (!_view_w) {
        _view_w = Screen_W;
    }
    return _view_w;
}
@end
