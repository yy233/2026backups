//
//  ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell.h"

@implementation ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.centerBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleL.superview);
        make.height.offset(40);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerBtn.superview);
        make.top.equalTo(_titleL.mas_bottom);
        make.bottom.equalTo(_centerBtn.superview).offset(-20);
    }];
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"请正对手机，确保光纤充足";
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textColor = Color_51BlackColor;
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn newAnBtnWithImg:[UIImage imageNamed:@"illustration"]];
        _centerBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_centerBtn addTarget:self action:@selector(centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}
#pragma mark ===
- (void)centerBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellSubCenterBtnTouch)]) {
        [_delegate cellSubCenterBtnTouch];
    }
}
@end
