//
//  HouseBuniesShopSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/4.
//

#import "HouseBuniesShopSectionHeaderView.h"
#define SUB_BTN_TAG 300
#define SUB_BTN_W   (Screen_W/4)
#define SUB_BTN_H   30

@implementation HouseBuniesShopSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backView addSubview:self.areaSpaceBtn];//面积
        [self setNewUI];
        self.houseTypeBtn.hidden = YES;
    }
    return self;
}
- (void)subBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag-SUB_BTN_TAG;
     switch (index) {
         case 1:
         {
             if (_delegateBuniesShop && [_delegateBuniesShop respondsToSelector:@selector(touchUpBuniesShopCityQuBtn)]) {
                 [_delegateBuniesShop touchUpBuniesShopCityQuBtn];
             }
         }
             break;
         case 2:
         {
             if (_delegateBuniesShop && [_delegateBuniesShop respondsToSelector:@selector(touchUpBuniesShopMoneyBtn)]) {
                 [_delegateBuniesShop touchUpBuniesShopMoneyBtn];
             }
         }
             break;
         case 3:
         {
             if (_delegateBuniesShop && [_delegateBuniesShop respondsToSelector:@selector(touchUpBuniesShopAreaSpaceBtn)]) {
                 [_delegateBuniesShop touchUpBuniesShopAreaSpaceBtn];
             }
         }
             break;
         case 4:
         {
             if (_delegateBuniesShop && [_delegateBuniesShop respondsToSelector:@selector(touchUpBuniesShopMoreBtn)]) {
                 [_delegateBuniesShop touchUpBuniesShopMoreBtn];
             }
         }
             break;
             
         default:
             break;
     }
}

- (void)setNewUI{
    [_areaSpaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyBtn.mas_right);
        make.top.equalTo(_areaSpaceBtn.superview.mas_top);
        make.width.offset(SUB_BTN_W);
        make.height.offset(SUB_BTN_H);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_areaSpaceBtn.mas_right);
        make.top.equalTo(_areaSpaceBtn.superview.mas_top);
        make.width.offset(SUB_BTN_W);
        make.height.offset(SUB_BTN_H);
    }];
}
- (UIButton *)areaSpaceBtn{
    if (!_areaSpaceBtn) {
        _areaSpaceBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_areaSpaceBtn setTitle:@"面积" forState:UIControlStateNormal];
        [_areaSpaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _areaSpaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_areaSpaceBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _areaSpaceBtn.tag = 3+SUB_BTN_TAG;
    }
    return _areaSpaceBtn;
}
@end
