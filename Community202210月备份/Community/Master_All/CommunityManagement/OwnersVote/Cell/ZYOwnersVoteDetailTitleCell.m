//
//  ZYOwnersVoteDetailTitleCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYOwnersVoteDetailTitleCell.h"

@interface ZYOwnersVoteDetailTitleCell ()

@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYOwnersVoteDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.subView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.subView.backgroundColor = [UIColor zy_colorWithHexString:@"#000F26"];
    }
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYOwnersVoteDetailDataVoteTopicEntityModel *)model {
    _model = model;
    
    self.titleLabel.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
