//
//  ZYProcessEvidenceTopCell.m
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import "ZYProcessEvidenceTopCell.h"

@interface ZYProcessEvidenceTopCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *judicialLabel;

@property (weak, nonatomic) IBOutlet UIImageView *judicialImageView;

@property (weak, nonatomic) IBOutlet UILabel *reliabilityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *reliabilityImageView;

@property (weak, nonatomic) IBOutlet UILabel *traceabilityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *traceabilityImageView;

@property (weak, nonatomic) IBOutlet UILabel *tamperLabel;

@property (weak, nonatomic) IBOutlet UIImageView *tamperImageView;

@end

@implementation ZYProcessEvidenceTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.topView.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kScreenW - 32, 155) direction:IHGradientChangeDirectionVertical startColor:Y_RGBA(60, 156, 255, 1) endColor:Y_RGBA(37, 95, 255, 1)];
    }else {
        self.topView.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kScreenW - 32, 155) direction:IHGradientChangeDirectionVertical startColor:Y_RGBA(17, 41, 87, 1) endColor:Y_RGBA(3, 31, 73, 1)];
    }
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.extractButton.layer.borderWidth = 0.5;
    self.extractButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.judicialLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.judicialImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_Judicial_chain"];
    self.reliabilityLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.reliabilityImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_reliability"];
    self.traceabilityLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.traceabilityImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_traceability"];
    self.tamperLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.tamperImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_Tamper_proof"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
