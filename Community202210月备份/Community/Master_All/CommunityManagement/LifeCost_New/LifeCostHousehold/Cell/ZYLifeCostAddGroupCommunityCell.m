//
//  ZYLifeCostAddGroupCommunityCell.m
//  Community
//
//  Created by ZY on 2022/1/7.
//

#import "ZYLifeCostAddGroupCommunityCell.h"

@interface ZYLifeCostAddGroupCommunityCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYLifeCostAddGroupCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYLifeCostNearCommunityModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    self.addressLabel.text = _model.detailAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
