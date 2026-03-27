//
//  ZYActivityApplyDetailInstructionsCell.m
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import "ZYActivityApplyDetailInstructionsCell.h"

@interface ZYActivityApplyDetailInstructionsCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;

@property (weak, nonatomic) IBOutlet UILabel *acticityDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *placesLabel;

@end

@implementation ZYActivityApplyDetailInstructionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.topView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.topView.backgroundColor = [UIColor zy_colorWithHexString:@"#000F26"];
    }
    self.titleLabel1.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel2.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel3.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel4.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.acticityDateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.applyDateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.placesLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYActivityApplyDetailDataModel *)model {
    _model = model;
    
    self.acticityDateLabel.text = [NSString stringWithFormat:@"%@-%@", _model.beginActivityTime.xh_format_yyyy_MM_dd_HH_mm, _model.overActivityTime.xh_format_yyyy_MM_dd_HH_mm];
    self.applyDateLabel.text = [NSString stringWithFormat:@"%@-%@", _model.beginApplyTime.xh_format_yyyy_MM_dd_HH_mm, _model.overApplyTime.xh_format_yyyy_MM_dd_HH_mm];
    self.placesLabel.text = [NSString stringWithFormat:@"共%ld名额", _model.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
