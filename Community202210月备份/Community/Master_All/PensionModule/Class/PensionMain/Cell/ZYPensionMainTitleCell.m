//
//  ZYPensionMainTitleCell.m
//  Community
//
//  Created by ZY on 2021/11/4.
//

#import "ZYPensionMainTitleCell.h"

@implementation ZYPensionMainTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.addMoreButton];
    [_addMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addMoreButton.superview);
        make.right.equalTo(_addMoreButton.superview).offset(-16);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIButton *)addMoreButton {
    if (!_addMoreButton) {
        _addMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addMoreButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addMoreButton setTitleColor:Y_RGBA(43, 44, 47, 1) forState:UIControlStateNormal];
        _addMoreButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, 0, -10, 0);
    }
    
    return _addMoreButton;
}

@end
