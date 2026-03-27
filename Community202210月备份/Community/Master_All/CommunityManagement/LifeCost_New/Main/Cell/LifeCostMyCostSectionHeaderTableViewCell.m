//
//  LifeCostMyCostSectionHeaderTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import "LifeCostMyCostSectionHeaderTableViewCell.h"

@implementation LifeCostMyCostSectionHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillBtnShowAddressStr:(NSString *)addressStr{
    if (addressStr.length<=0) {
        addressStr = @"默认缴费组";
    }
    self.titleL.text = addressStr;
}
- (void)fillBtnShowSouFangBool:(BOOL)soufangBool{
    self.souFangBtn.selected = soufangBool;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.souFangBtn];
        [self.backV addSubview:self.editBtn];
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
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_backV);
        make.width.offset(30);
    }];
    [_souFangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_editBtn.mas_left).offset(-10);
        make.top.bottom.equalTo(_backV);
        make.width.offset(30);
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
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"默认缴费组";
    }
    return _titleL;
}

- (UIButton *)souFangBtn{
    if (!_souFangBtn) {
        _souFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_souFangBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"shangLa"] selectedImg:[UIImage imageNamed:@"xiaLa"]];
        [_souFangBtn addTarget:self action:@selector(souFangBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _souFangBtn;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"gengduo_BlackColor"]];
        }else{
            [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"gengduo_Dark"]];
        }
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _editBtn;
}
 
#pragma mark ==
- (void)souFangBtnAction{
    if (isNotNil(self.souFangBtnBlock)) {
        self.souFangBtnBlock();
    }
}
- (void)editBtnAction{
    if (isNotNil(self.editBtnBlock)) {
        self.editBtnBlock();
    }
}


@end
