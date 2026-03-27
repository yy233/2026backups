//
//  ZYElectronicNewsDetailShowCell.m
//  Community
//
//  Created by ZY on 2021/9/7.
//

#import "ZYElectronicNewsDetailShowCell.h"

@interface ZYElectronicNewsDetailShowCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYElectronicNewsDetailShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].threeLevelTitleThemeColor_Dc5c9d4;
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    [self.contentImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
}

// 设置数据model
- (void)setModel:(ZYContractKnowledgeListDataListModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
    self.dateLabel.text = _model.createTime;
    self.contentLabel.text = _model.content;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, _model.image]];
    [self.contentImageView sd_setImageWithURL:url placeholderImage: [UIImage imageNamed:@"p3"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
