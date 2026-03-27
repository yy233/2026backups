//
//  LifeCostPayTypeHeaderTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import "LifeCostPayTypeHeaderTableViewCell.h"

@implementation LifeCostPayTypeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillHeaderCellCityNameWithStr:(NSString *)cityName{
    if (cityName.length<=0) {
        cityName = @"选择地区";
    }
    [self.cityChangeBtn setTitle:cityName forState:UIControlStateNormal];
    [self.cityChangeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.cityChangeBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview).insets(UIEdgeInsetsMake(0, 16, 0, 26));
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backV).offset(10);
        make.top.bottom.equalTo(_backV);
        make.width.equalTo(_backV).multipliedBy(0.6);
    }];
    [_cityChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backV.mas_right).offset(-10);
        make.top.bottom.equalTo(_backV);
    }];
}
#pragma mark ==
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _backV.layer.cornerRadius = 7.0;
    }
    return _backV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:16.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"新增缴费";
    }
    return _titleL;
}

 
- (UIButton *)cityChangeBtn{
    if (!_cityChangeBtn) {
        _cityChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityChangeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_cityChangeBtn setTitleColor:[ThemeManager shareManager].mainTextColor   forState:UIControlStateNormal];
        [_cityChangeBtn setTitle:@"选择地区" forState:UIControlStateNormal];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_cityChangeBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala"]];
        }else{
            [_cityChangeBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala_zhouye"]];
        }
        [_cityChangeBtn addTarget:self action:@selector(cityChangeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityChangeBtn;
}

#pragma mark ==
- (void)cityChangeBtnAction{
    if (isNotNil(self.headerCellCityChangeBtnBlock)) {
        self.headerCellCityChangeBtnBlock();
    }
}
@end
