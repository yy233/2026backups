//
//  SmallShopInfoListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/26.
//

#import "SmallShopInfoListTableViewCell.h"

@implementation SmallShopInfoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];// [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.titleLabel.textColor = [UIColor blackColor];
    }
    return self;
}
@end
