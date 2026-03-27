//
//  ZYCarInvitePayCell.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInvitePayCell.h"

@interface ZYCarInvitePayCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *carStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratesTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratesLabel;

@property (weak, nonatomic) IBOutlet UILabel *favourablePriceTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *avourablePriceLabel;

@property (weak, nonatomic) IBOutlet UIView *firstStopView;

@property (weak, nonatomic) IBOutlet UILabel *firstStopLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStopWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView1;

@end

@implementation ZYCarInvitePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.carNumLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.carStatusLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.durationTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.durationLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.ratesTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.ratesLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.favourablePriceTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.avourablePriceLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.firstStopLabel.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(20, 11) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#FF8587"] endColor:[UIColor zy_colorWithHexString:@"#FF4D4F"]];
    self.lineImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ci_dotted_line"];
    self.lineImageView1.image = [[ZYThemeManager shareManager] themeImageNamed:@"ci_dotted_line"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
