//
//  ZYAccessRecordCell.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordCell.h"

@interface ZYAccessRecordCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *accessImageView;

@end

@implementation ZYAccessRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYAccessRecordDataListModel *)model {
    _model = model;
    
    [self.iconImageView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.snapFaceUrl] placeholderImage:[[ZYThemeManager shareManager] themeImageNamed:@"ar_chejing_d"]];
    self.nameLabel.text = _model.facesluiceName;
    self.timeLabel.text = _model.createTime.xh_format_HH_mm;
    if ([_model.direction isEqual:@"进口"]) {
        self.accessImageView.image = [UIImage imageNamed:@"ar_jin_icon"];
    }else {
        self.accessImageView.image = [UIImage imageNamed:@"ar_chu_icon"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
