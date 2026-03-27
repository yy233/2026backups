//
//  ChatFriendSetRightSiderTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/17.
//

#import "ChatFriendSetRightSiderTableViewCell.h"

@implementation ChatFriendSetRightSiderTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(5, 32, 5, 16));
        }];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.cellSwith];
        [self serUI];
    }
    return self;
}
- (void)serUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(_titleL.superview);
        make.right.equalTo(_titleL.superview).offset(-100);
        make.height.offset(20);
    }];
    [_cellSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(_cellSwith.superview);
        make.height.offset(35);
        make.width.offset(60);
    }];
 
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"设置星标朋友";
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = Y_ColorWith16FromRGB(0x333333);
    }
    return _titleL;
}
 
- (UISwitch *)cellSwith{
    if (!_cellSwith) {
        _cellSwith = [[UISwitch alloc]init];
        _cellSwith.frame = CGRectMake(0, 0, 60 , 30);
        _cellSwith.onTintColor = Color_38BlueColor;
    }
    return _cellSwith;
}
@end
