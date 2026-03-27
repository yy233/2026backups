//
//  MyHouseAddSubPersonVCLateWithTextFiledTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/26.
//

#import "MyHouseAddSubPersonVCLateWithTextFiledTableViewCell.h"

@implementation MyHouseAddSubPersonVCLateWithTextFiledTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//重写颜色
- (void)prepareForReuse{
    [super prepareForReuse];
    self.backView.backgroundColor = [UIColor clearColor];//保持所需的颜色 防止willDisplayCell写的分割线 被 视图清空后初始的颜色给遮住了
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backView.backgroundColor = [UIColor clearColor];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.textField.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}
@end
