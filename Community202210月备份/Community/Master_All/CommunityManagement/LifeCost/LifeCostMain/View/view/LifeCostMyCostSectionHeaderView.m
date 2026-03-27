//
//  LifeCostMyCostSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "LifeCostMyCostSectionHeaderView.h"
@interface LifeCostMyCostSectionHeaderView ()
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UILabel *titleL;

@end
@implementation LifeCostMyCostSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backV];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.householdManagementBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_backV.superview).insets(UIEdgeInsetsMake(0, 16.0, -8.0, 16.0));//7
        make.edges.equalTo(_backV.superview).insets(UIEdgeInsetsMake(0, 16.0, -1, 16.0));//7
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.left.equalTo(_titleL.superview).offset(10);
        make.width.offset(70);
        make.height.offset(20);
    }];
    [_householdManagementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_householdManagementBtn.superview).offset(10);
        make.right.equalTo(_householdManagementBtn.superview.mas_right).offset(-10);
        make.width.offset(90);
        make.height.offset(20);
    }];
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"地区名";
    }
    return _titleL;
}
- (UIButton *)householdManagementBtn{
    if (!_householdManagementBtn) {
        _householdManagementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _householdManagementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_householdManagementBtn setTitle:@"户号管理" forState:UIControlStateNormal];
        [_householdManagementBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
//        [_householdManagementBtn setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
    }
    return _householdManagementBtn;
}
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _backV.layer.cornerRadius = 7.0;
    }
    return _backV;
}
@end
