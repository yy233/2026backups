//
//  HouseRepairOldInputLookDetailShowContentTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import "HouseRepairOldInputLookDetailShowContentTextTableViewCell.h"

@interface HouseRepairOldInputLookDetailShowContentTextTableViewCell ()
@property (nonatomic,strong) UILabel *contentL;
@end

@implementation HouseRepairOldInputLookDetailShowContentTextTableViewCell

- (void)fillContentStr:(NSString *)contentStr{
    
    self.contentL.text = contentStr;
}

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
        [self.contentView addSubview:self.contentL];
        [self setUI];
    }
    return  self;
}
- (void)setUI{
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentL.superview).insets(UIEdgeInsetsMake(0, 26, 0, 26));
    }];
}


- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.numberOfLines = 0;
        _contentL.font = [UIFont systemFontOfSize:12.0];
        //_contentL.textColor = Y_ColorWith16FromRGB(0xC5C9D4);//[ThemeManager shareManager].mainTextColor;
        _contentL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _contentL;
}
@end
