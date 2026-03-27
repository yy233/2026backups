//
//  MyOrderDetailVcSendInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "MyOrderDetailVcSendInfoTableViewCell.h"

@implementation MyOrderDetailVcSendInfoTableViewCell

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
        self.lineV.hidden = YES;
        self.topTitleL.textColor = Color_153GrayColor;
        self.detailL.textColor = [UIColor blackColor];
        self.topTitleL.font = FontSize_Orders_Nomail(13);
        self.detailL.font = FontSize_Orders_Nomail(13);
        [self.topTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topTitleL.superview.mas_left).offset(10);
            make.top.bottom.equalTo(self.topTitleL.superview);
            make.width.offset(90);
        }];
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topTitleL.mas_right);
            make.bottom.top.equalTo(self.detailL.superview);
            make.right.equalTo(self.detailL.superview.mas_right).offset(-10);
        }];
        self.detailL.textAlignment = NSTextAlignmentRight;
    }
    return self;
    
}
@end
