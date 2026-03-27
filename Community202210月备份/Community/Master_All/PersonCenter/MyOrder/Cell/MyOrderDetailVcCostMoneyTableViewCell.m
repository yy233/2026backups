//
//  MyOrderDetailVcCostMoneyTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "MyOrderDetailVcCostMoneyTableViewCell.h"

@implementation MyOrderDetailVcCostMoneyTableViewCell

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
        [self.topTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {//MoneyNum
            make.right.equalTo(self.topTitleL.superview).offset(-10);
            make.centerY.equalTo(self.topTitleL.superview);
            make.height.equalTo(self.topTitleL.superview);
        }];
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topTitleL.mas_left).offset(-10);
            make.centerY.height.equalTo(self.topTitleL);
        }];
        self.topTitleL.textAlignment = NSTextAlignmentRight;
        self.topTitleL.font = FontSize_Orders_Bold(22);
        self.detailL.font = FontSize_Orders_Bold(13);
        self.detailL.textColor = [UIColor blackColor];
    }
    return self;
}
@end
