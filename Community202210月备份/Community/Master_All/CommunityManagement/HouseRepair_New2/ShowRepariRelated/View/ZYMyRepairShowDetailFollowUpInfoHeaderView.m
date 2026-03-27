//
//  ZYMyRepairShowDetailFollowUpInfoHeaderView.m
//  Community
//
//  Created by ZY on 2022/4/13.
//

#import "ZYMyRepairShowDetailFollowUpInfoHeaderView.h"

@interface ZYMyRepairShowDetailFollowUpInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYMyRepairShowDetailFollowUpInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.topLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#B9D2FF"];
        self.bottomLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#B9D2FF"];
    }else {
        self.topLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#436298"];
        self.bottomLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#436298"];
    }
}

// 设置数据model
- (void)setModel:(ZYMyRepairShowDetailFollowUpInfoModel *)model {
    _model = model;
    
    self.dateLabel.text = _model.createTime;
    self.titleLabel.text = _model.opTypeStr;
}

@end
