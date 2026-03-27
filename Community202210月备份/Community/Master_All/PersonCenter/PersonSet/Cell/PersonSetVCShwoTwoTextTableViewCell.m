//
//  PersonSetVCShwoTwoTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/29.
//

#import "PersonSetVCShwoTwoTextTableViewCell.h"

@implementation PersonSetVCShwoTwoTextTableViewCell

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
        [self.contentView addSubview:self.rightTextL];
        [_rightTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_rightTextL.superview);
            make.right.equalTo(_rightTextL.superview).offset(-16);
        }];
    }
    return self;
}
- (UILabel *)rightTextL{
    if (!_rightTextL) {
        _rightTextL = [[UILabel alloc]init];
        _rightTextL.font = [UIFont systemFontOfSize:15.0];
        _rightTextL.textAlignment = NSTextAlignmentRight;
    }
    return _rightTextL;
}
@end
