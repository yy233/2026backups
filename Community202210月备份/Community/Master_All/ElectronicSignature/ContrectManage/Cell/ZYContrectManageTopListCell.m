//
//  ZYContrectManageTopListCell.m
//  Community
//
//  Created by ZY on 2021/8/30.
//

#import "ZYContrectManageTopListCell.h"

@interface ZYContrectManageTopListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYContrectManageTopListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYContrectManageTopListModel *)model {
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)", _model.title, _model.num];
    if (_model.isSelected) {
        self.titleLabel.textColor = Y_RGBA(255, 0, 51, 1);
    }else {
        self.titleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
