//
//  LifeCostNewCostSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "LifeCostNewCostSectionHeaderView.h"
@interface LifeCostNewCostSectionHeaderView ()
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UILabel *titleL;
@end
@implementation LifeCostNewCostSectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backV];
        [self.backV addSubview:self.titleL];
//        [self  addSubview:self.cityChooseDropdownListView];//
        [self.backV addSubview:self.cityChangeBtn];
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
    [_cityChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityChangeBtn.superview).offset(10);
        make.right.equalTo(_cityChangeBtn.superview.mas_right).offset(-10);
        make.width.offset(90);
        make.height.offset(20);
    }];
//    [_cityChooseDropdownListView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_cityChangeBtn).insets(UIEdgeInsetsMake(0, -10, 0, -10));
//    }];
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"新增缴费";
    }
    return _titleL;
}
- (UIButton *)cityChangeBtn{
    if (!_cityChangeBtn) {
        _cityChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityChangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cityChangeBtn setTitle:@"重庆" forState:UIControlStateNormal];
        [_cityChangeBtn setTitleColor:[ThemeManager shareManager].mainTextColor   forState:UIControlStateNormal];
//        [_householdManagementBtn setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
    }
    return _cityChangeBtn;
}
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _backV.layer.cornerRadius = 7.0;
    }
    return _backV;
}
//- (EBDropdownListView *)cityChooseDropdownListView{
//    // 弹出框向下
//    if (!_cityChooseDropdownListView) {
//        _cityChooseDropdownListView = [EBDropdownListView new];
//        _cityChooseDropdownListView.selectedIndex = 1;
//        [_cityChooseDropdownListView setViewBorder:0.5 borderColor:[UIColor grayColor] cornerRadius:2];
//        [_cityChooseDropdownListView setTextColor:[ThemeManager shareManager].mainTextColor];
//        [_cityChooseDropdownListView setFont:[UIFont systemFontOfSize:14]];
//    }
//    return _cityChooseDropdownListView;
//}
@end
