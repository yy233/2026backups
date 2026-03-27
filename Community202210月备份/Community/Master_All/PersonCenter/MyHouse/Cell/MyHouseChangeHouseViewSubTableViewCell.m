//
//  MyHouseChangeHouseViewSubTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "MyHouseChangeHouseViewSubTableViewCell.h"

@implementation MyHouseChangeHouseViewSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.typeBtn];
        [self.backView addSubview:self.bottomL];
        [self setCellUI];
    }
    return self;
}
- (void)setCellUI{
    WEAKSELF
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleL.superview).offset(10);
        make.height.offset(20);
        make.top.equalTo(weakSelf.titleL.superview).offset(5);
    }];
    [_typeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.centerY.height.equalTo(weakSelf.titleL);
        make.left.equalTo(weakSelf.titleL.mas_right).offset(5);
        make.right.lessThanOrEqualTo(_typeBtn.superview.mas_right).offset(-50);
    }];
    
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.titleL.superview).offset(-5);
        make.height.left.equalTo(weakSelf.titleL);
        make.right.equalTo(_bottomL.superview.mas_right).offset(-50);
    }];
}

#pragma mark ==
- (UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
    }
    return _typeBtn;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.textColor = Y_ColorWith16FromRGB(0x333333);
        _bottomL.font = [UIFont systemFontOfSize:13];
    }
    return _bottomL;
}
@end
