//
//  ZYActivityApplyCell.m
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import "ZYActivityApplyCell.h"

@interface ZYActivityApplyCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYActivityApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

// 设置数据model
- (void)setModel:(ZYActivityApplyDataListModel *)model {
    _model = model;
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld", _model.order];
    self.titleLabel.text = _model.theme;
    self.dateLabel.text = [NSString stringWithFormat:@"报名时间：%@-%@", _model.beginApplyTime.xh_format_yyyy_MM_dd_HH_mm, _model.overApplyTime.xh_format_yyyy_MM_dd_HH_mm];
    
    NSLog(@"w=%lf", kScreenW);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
