//
//  ZYMyMedicaCell.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYMyMedicaCell.h"

@interface ZYMyMedicaCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYMyMedicaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, 62, 0, 0);
}

// 设置数据model
- (void)setModel:(ZYMyMedicaModel *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:_model.iconImageName];
    self.titleLabel.text = _model.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
