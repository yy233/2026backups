//
//  ZYLeadFamilyArchiveCell.m
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import "ZYLeadFamilyArchiveCell.h"

@interface ZYLeadFamilyArchiveCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation ZYLeadFamilyArchiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
}

// 设置数据model
- (void)setModel:(ZYLeadFamilyArchiveModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    self.telLabel.text = _model.mobile;
    if (_model.isSelected) {
        self.selectImageView.image = [UIImage imageNamed:@"yl_f_gouxuan"];
    }else {
        self.selectImageView.image = [UIImage imageNamed:@"yl_f_quanquan"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
