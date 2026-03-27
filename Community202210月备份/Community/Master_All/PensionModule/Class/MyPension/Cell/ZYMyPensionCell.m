//
//  ZYMyPensionCell.m
//  Community
//
//  Created by ZY on 2021/11/9.
//

#import "ZYMyPensionCell.h"

@interface ZYMyPensionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYMyPensionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 62, 0, 0);
}

// 设置数据model
- (void)setModel:(ZYMyPensionModel *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:_model.iconImageName];
    self.titleLabel.text = _model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
