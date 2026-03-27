//
//  ZYContractingPartyInformationSearchCell.m
//  Community
//
//  Created by ZY on 2021/5/21.
//

#import "ZYContractingPartyInformationSearchCell.h"

@interface ZYContractingPartyInformationSearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation ZYContractingPartyInformationSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYContractingPartyInformationSearchModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.idCardName;
    self.telLabel.text = _model.telephone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
