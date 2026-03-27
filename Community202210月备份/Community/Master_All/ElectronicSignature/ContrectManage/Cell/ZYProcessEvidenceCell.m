//
//  ZYProcessEvidenceCell.m
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import "ZYProcessEvidenceCell.h"

@interface ZYProcessEvidenceCell ()

@property (weak, nonatomic) IBOutlet UIView *contenV;

@property (weak, nonatomic) IBOutlet UIImageView *upDownImageView;

@property (weak, nonatomic) IBOutlet UILabel *partNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet UIView *partContentView;

@property (weak, nonatomic) IBOutlet UILabel *signNameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *IdCardTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *ipTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *signNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *IdCardLabel;

@property (weak, nonatomic) IBOutlet UILabel *ipLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (weak, nonatomic) IBOutlet UIView *line3View;

@property (weak, nonatomic) IBOutlet UIView *line4View;

@property (weak, nonatomic) IBOutlet UIView *line5View;

@property (weak, nonatomic) IBOutlet UIView *line6View;

@property (weak, nonatomic) IBOutlet UIView *line7View;

@property (weak, nonatomic) IBOutlet UIView *line8View;

@property (weak, nonatomic) IBOutlet UIView *line9View;

@property (weak, nonatomic) IBOutlet UIView *line10View;

@property (weak, nonatomic) IBOutlet UIView *line11View;

@end

@implementation ZYProcessEvidenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contenV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.startLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.signLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.signNameTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.signNameLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.IdCardTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.IdCardLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.ipTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.ipLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.adressTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.adressLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.deviceTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.deviceLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    
    self.line1View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line2View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line3View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line4View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line5View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line6View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line7View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line8View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line9View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line10View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line11View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.telButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
}

// 设置数据model
- (void)setModel:(ZYProcessEvidenceDataListDataModel *)model {
    _model = model;
    
    if (_model.roleType == 0) {
        self.partNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }else if (_model.roleType == 1) {
        self.partNameLabel.textColor = Y_RGBA(38, 114, 249, 1);
    }else {
        self.partNameLabel.textColor = Y_RGBA(0, 204, 171, 1);
    }
    
    if (_model.isSelected) {
        self.partContentView.hidden = NO;
        self.upDownImageView.image = [UIImage imageNamed:@"ic_take_back"];
    }else {
        self.partContentView.hidden = YES;
        self.upDownImageView.image = [UIImage imageNamed:@"ic_drop_down"];
    }
    
    self.partNameLabel.text = _model.role;
    self.startLabel.text = _model.signTime;
    self.signLabel.text = _model.describe;
    self.signNameLabel.text = _model.signName;
    self.IdCardLabel.text = _model.licenseId;
    self.ipLabel.text = _model.ipAddr;
    self.adressLabel.text = _model.positionInfo;
    self.deviceLabel.text = _model.deviceInfo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
