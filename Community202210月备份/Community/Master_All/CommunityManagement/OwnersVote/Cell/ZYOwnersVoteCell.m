//
//  ZYOwnersVoteCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYOwnersVoteCell.h"

@interface ZYOwnersVoteCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYOwnersVoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

// 设置数据model
- (void)setModel:(ZYOwnersVoteListDataListModel *)model {
    _model = model;
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld", _model.order];
    self.titleLabel.text = _model.theme;
    self.dateLabel.text = [NSString stringWithFormat:@"报名时间：%@-%@", _model.beginTime.xh_format_yyyy_MM_dd_HH_mm, _model.overTime.xh_format_yyyy_MM_dd_HH_mm];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
