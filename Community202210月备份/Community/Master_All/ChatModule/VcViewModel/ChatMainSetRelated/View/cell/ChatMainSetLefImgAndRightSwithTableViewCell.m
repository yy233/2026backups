//
//  ChatMainSetRightSwithTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/17.
//

#import "ChatMainSetLefImgAndRightSwithTableViewCell.h"

@implementation ChatMainSetLefImgAndRightSwithTableViewCell

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
        self.titleL.font = [UIFont systemFontOfSize:16];
        [self.backView addSubview:self.leftImgV];
        [self setMainCellUI];
    }
    return self;
}
- (void)setMainCellUI{
    [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(_leftImgV.superview);
        make.height.width.offset(20);
    }];
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImgV.mas_right).offset(16);
        make.centerY.equalTo(_leftImgV);
        make.height.offset(20);
        make.width.offset(80);
    }];
}
- (UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]init];
    }
    return _leftImgV;
}
@end
