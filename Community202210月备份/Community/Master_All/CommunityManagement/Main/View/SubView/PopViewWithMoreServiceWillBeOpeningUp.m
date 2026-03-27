//
//  PopViewWithMoreServiceWillBeOpeningUp.m
//  Community
//
//  Created by 余莹 on 2021/3/22.
//

#import "PopViewWithMoreServiceWillBeOpeningUp.h"
#define Self_Center_View_W      (Screen_W*0.6)
@implementation PopViewWithMoreServiceWillBeOpeningUp
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.subMainBackView addSubview:self.centerBackView];
        [self.centerBackView addSubview:self.imgView];
        [self.centerBackView addSubview:self.centerLabel];
        [self.centerBackView addSubview:self.baseFooterView];
        [self setUI];
        self.subMainBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
 
- (void)showInViewEditCellIndex:(NSInteger)index andWithArray:(NSMutableArray *)timeArr{
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    //up ui
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H;
}
#pragma mark ==
- (void)setUI{
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_centerBackView.superview);
        make.width.equalTo(_centerBackView.superview).multipliedBy(0.6);
        make.height.offset(230);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView.superview);
        make.width.offset(80);
        make.height.offset(60);
        make.top.equalTo(_imgView.superview.mas_top).offset(30);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerLabel.superview);
        make.top.equalTo(_imgView.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    [_baseFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerLabel.mas_bottom);
        make.bottom.equalTo(_baseFooterView.superview.mas_bottom);
        make.centerX.equalTo(_baseFooterView.superview);
        make.width.equalTo(_baseFooterView.superview).offset(-32);
    }];
    
}

- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.layer.cornerRadius = 7.5;
        _centerBackView.layer.masksToBounds = YES;
        _centerBackView.backgroundColor = [UIColor whiteColor];
    }
    return _centerBackView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"development_in"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
//        _centerLabel.text = @"更多社区服务正在逐步开放中";//这不能过审核
        _centerLabel.text = @"当前社区该服务正在准备中";
        _centerLabel.textColor = Color_51BlackColor;
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _centerLabel;
}
- (BaseTableViewFooterView *)baseFooterView{
    if (!_baseFooterView) {
        _baseFooterView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0,Self_Center_View_W-32 , 90)];
        [_baseFooterView setBtnFram:CGRectMake(16, 20, Self_Center_View_W-32, 44)];
        [_baseFooterView.footerBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_baseFooterView.footerBtn newAnBtnWithTextStr:@"好的"];
        [_baseFooterView.footerBtn addTarget:self action:@selector(popViewMoreServiceWillOpeningShow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baseFooterView;
}
- (void)popViewMoreServiceWillOpeningShow{
    [self dismissThePopView];
}
@end
