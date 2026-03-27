//
//  ZYSOSAddressBookHospitalCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddressBookHospitalCell.h"

@interface ZYSOSAddressBookHospitalCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *hospitalTelButton;

@property (weak, nonatomic) IBOutlet UIButton *changeHospitalButton;

@end

@implementation ZYSOSAddressBookHospitalCell
- (void)fillDataWithAgencyModel:(SosAddressBookAgencyModel *)model{
    
    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.shopName];
    [self.iconImageView sd_setImageWithURL: [UrlWithString getURLWithStr:model.shopLogo]  placeholderImage:[UIImage imageNamed:@"yl_yytox"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusRoundingRect];
    [self.hospitalTelButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:2];
    [self.changeHospitalButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.hospitalTelButton addTarget:self action:@selector(hospitalTelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.changeHospitalButton addTarget:self action:@selector(changeHospitalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)hospitalTelButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hospitalTelButtonEvent)]) {
        [self.delegate hospitalTelButtonEvent];
    }
}

- (void)changeHospitalButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeHospitalButtonEvent)]) {
        [self.delegate changeHospitalButtonEvent];
    }
}

@end
