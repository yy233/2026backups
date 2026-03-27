//
//  ZYCommunityFairDetailIllustrateCell.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairDetailIllustrateCell.h"

@interface ZYCommunityFairDetailIllustrateCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYCommunityFairDetailIllustrateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYCommunityFairDetailDataModel *)model {
    _model = model;
    
    self.contentLabel.text = _model.goodsExplain;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
