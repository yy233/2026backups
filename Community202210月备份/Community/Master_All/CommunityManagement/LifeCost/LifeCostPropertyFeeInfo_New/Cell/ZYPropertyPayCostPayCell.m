//
//  ZYPropertyPayCostPayCell.m
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import "ZYPropertyPayCostPayCell.h"

@interface ZYPropertyPayCostPayCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYPropertyPayCostPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.doubtButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.doubtButton addTarget:self action:@selector(doubtButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// 设置数据model
- (void)setModel:(ZYPropertyPayCostPayModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)doubtButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doubtButtonEvent)]) {
        [self.delegate doubtButtonEvent];
    }
}

@end
