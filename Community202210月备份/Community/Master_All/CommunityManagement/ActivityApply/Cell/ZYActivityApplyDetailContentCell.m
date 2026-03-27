//
//  ZYActivityApplyDetailContentCell.m
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import "ZYActivityApplyDetailContentCell.h"

@interface ZYActivityApplyDetailContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYActivityApplyDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYActivityApplyDetailDataModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.theme;
    self.contentLabel.text = _model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
