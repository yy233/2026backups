//
//  PaymentCompanyListHeaderSearchAndCityChooseView.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "PaymentCompanyListHeaderSearchAndCityChooseView.h"
#import "LifeCostSaveCityInfoModel.h"

@implementation PaymentCompanyListHeaderSearchAndCityChooseView


- (void)fillHeaderCellCityNameWithStr:(NSString *)cityName{
    if (cityName.length<=0) {
        cityName = @"选择地区";
    }
    [self.cityChangeBtn setTitle:cityName forState:UIControlStateNormal];
    [self.cityChangeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchBar];
        [self addSubview:self.cityChangeBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_cityChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cityChangeBtn.superview);
        make.height.equalTo(_cityChangeBtn.superview).offset(-10);
        make.right.equalTo(_cityChangeBtn.superview).offset(-16);
        make.width.lessThanOrEqualTo(_cityChangeBtn.superview);
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_searchBar.superview);
        make.left.equalTo(_searchBar.superview).offset(16);
        make.right.equalTo(_cityChangeBtn.mas_left).offset(-15);
    }];
    [self.cityChangeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];
}

#pragma mark ==
- (UISearchBar *)searchBar{
   if (!_searchBar) {
       _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(16, 0, Screen_W-100, 50)];
       _searchBar.placeholder = @"搜索缴费单位";
       _searchBar.searchTextField.textColor = [ThemeManager shareManager].mainTextColor;
       _searchBar.searchTextField.font = [UIFont systemFontOfSize:15.0];
       _searchBar.layer.masksToBounds = YES;
       _searchBar.backgroundColor = [UIColor clearColor];
       _searchBar.searchBarStyle = UISearchBarStyleMinimal;
   }
   return _searchBar;
}
- (UIButton *)cityChangeBtn{
   if (!_cityChangeBtn) {
       _cityChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [_cityChangeBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
       [_cityChangeBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
       if ([LifeCostSaveCityInfoModel share].cityName.length<=0) {
           [_cityChangeBtn newAnBtnWithTextStr:@"选择地区"];
       }else{
           [_cityChangeBtn newAnBtnWithTextStr:[LifeCostSaveCityInfoModel share].cityName];
       }
       if ([ThemeManager shareManager].type == ThemeType_White) {
           [_cityChangeBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala"]];
       }else{
           [_cityChangeBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala_zhouye"]];
       }
       
   }
   return _cityChangeBtn;
}

@end
