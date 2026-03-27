//
//  ZYBlockchainOrderEvidenceCell.m
//  Community
//
//  Created by ZY on 2021/10/29.
//

#import "ZYBlockchainOrderEvidenceCell.h"

@interface ZYBlockchainOrderEvidenceCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *transactionNameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *transactionNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *payElectronicIdentityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *payElectronicIdentityLabel;

@property (weak, nonatomic) IBOutlet UILabel *payTypeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *payeeElectronicIdentityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *payeeElectronicIdentityLabel;

@property (weak, nonatomic) IBOutlet UILabel *timestampTitltLabel;

@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *hashTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *hashLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailedListTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailedListLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarksTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;

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

@implementation ZYBlockchainOrderEvidenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    
    self.transactionNameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.transactionNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.payElectronicIdentityTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.payElectronicIdentityLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.payTypeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.payTypeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.currencyTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.currencyLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.totalAmountTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.totalAmountLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.payeeElectronicIdentityTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.payeeElectronicIdentityLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timestampTitltLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timestampLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.orderNumTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.orderNumLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.hashTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.hashLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.detailedListTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.detailedListLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.remarksTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.remarksLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
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
- (void)setModel:(ZYBlockchainOrderEvidenceModel *)model {
    _model = model;
    
    self.transactionNameLabel.text = _model.transactionName;
    self.payElectronicIdentityLabel.text = _model.payElectronicIdentity;
    self.payTypeLabel.text = _model.payType;
    self.currencyLabel.text = _model.currency;
    self.totalAmountLabel.text = _model.totalAmount;
    self.payeeElectronicIdentityLabel.text = _model.payeeElectronicIdentity;
    self.timestampLabel.text = _model.timestamp;
    self.orderNumLabel.text = _model.orderNum;
    self.hashLabel.text = _model.hashStr;
    self.detailedListLabel.text = _model.detailedList;
    self.remarksLabel.text = _model.remarks;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
