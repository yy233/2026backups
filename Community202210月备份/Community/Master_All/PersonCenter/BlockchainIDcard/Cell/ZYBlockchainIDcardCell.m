//
//  ZYBlockchainIDcardCell.m
//  Community
//
//  Created by ZY on 2021/10/28.
//

#import "ZYBlockchainIDcardCell.h"

@interface ZYBlockchainIDcardCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *uidTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *uidLabel;

@property (weak, nonatomic) IBOutlet UILabel *idCardTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;

@property (weak, nonatomic) IBOutlet UILabel *hashTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *hashLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *judicialLabel;

@property (weak, nonatomic) IBOutlet UIImageView *judicialImageView;

@property (weak, nonatomic) IBOutlet UILabel *reliabilityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *reliabilityImageView;

@property (weak, nonatomic) IBOutlet UILabel *traceabilityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *traceabilityImageView;

@property (weak, nonatomic) IBOutlet UILabel *tamperLabel;

@property (weak, nonatomic) IBOutlet UIImageView *tamperImageView;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation ZYBlockchainIDcardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.uidTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.uidLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.idCardTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.idCardLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.hashTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.hashLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.judicialLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.judicialImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_Judicial_chain"];
    self.reliabilityLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.reliabilityImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_reliability"];
    self.traceabilityLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.traceabilityImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_traceability"];
    self.tamperLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.tamperImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_Tamper_proof"];
    
    self.bottomLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYBlockchainIDcardDataModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.idCardName;
    self.uidLabel.text = _model.blockAddress;
    self.idCardLabel.text = _model.idCardNo;
    self.hashLabel.text = _model.hashStr;
    self.timeLabel.text = _model.timeStamp;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
