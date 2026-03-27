//
//  ZYCommunityFairDetailContentCell.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairDetailContentCell.h"

@interface ZYCommunityFairDetailContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation ZYCommunityFairDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYCommunityFairDetailDataModel *)model {
    _model = model;
    
    self.markLabel.text = _model.labelName;
    CGSize markSize = [self.markLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.markLabel.font} context:nil].size;
    self.markLabelWidthConstraint.constant = markSize.width + 10;
    
    self.nameLabel.text = _model.goodsName;
    if (_model.negotiable == 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@", _model.price];
    }else {
        self.moneyLabel.text = @"面议";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
