//
//  ZYElectronicNewsCommentsListCell.m
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import "ZYElectronicNewsCommentsListCell.h"

@interface ZYElectronicNewsCommentsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYElectronicNewsCommentsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].threeLevelTitleThemeColor_Dc5c9d4;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:14 rectCornerType:UIRectCornerAllCorners];
}

// 设置数据model
- (void)setModel:(ZYCommentsListDataListModel *)model {
    _model = model;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, _model.image]];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    if (_model.nickName.length > 0) {
        self.nameLabel.text = _model.nickName;
    }else {
        self.nameLabel.text = @"匿名";
    }
    self.contentLabel.text = _model.content;
    self.dateLabel.text = _model.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
