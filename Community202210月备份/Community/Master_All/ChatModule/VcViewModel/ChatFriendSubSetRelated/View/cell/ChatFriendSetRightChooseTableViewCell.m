//
//  ChatFriendSetRightChooseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/17.
//

#import "ChatFriendSetRightChooseTableViewCell.h"

@implementation ChatFriendSetRightChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellSetChooseBool:(BOOL)isChooseBool{
    if (isChooseBool) {
        self.accessoryType =   UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType =   UITableViewCellAccessoryNone;
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellSwith.hidden = YES;
        self.accessoryType =   UITableViewCellAccessoryCheckmark;

//        self.cellSwith.hidden = YES;
//        [self.backView addSubview:self.rightChooseImgView];
//        [self serRightUI];
    }
    return self;
}
- (void)serRightUI{
    [_rightChooseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(_rightChooseImgView.superview);
        make.height.offset(35);
        make.width.offset(20);
    }];
    
}
- (UIImageView *)rightChooseImgView{
    if (!_rightChooseImgView) {
        _rightChooseImgView = [[UIImageView alloc]init];
//        _rightChooseImgView.image = [UIImage imageNamed:@""];
    }
    return _rightChooseImgView;
}

@end
