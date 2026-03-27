//
//  ZYSigningDetailLandlordInfoCell.m
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import "ZYSigningDetailLandlordInfoCell.h"

@interface ZYSigningDetailLandlordInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ZYSigningDetailLandlordInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    CGRect bounds = CGRectMake(0, 0, kScreenW - 32, self.contentV.bounds.size.height);
    [self.contentV cornerRadiusWithBounds:bounds radius:7.5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.landlordName;
    self.telLabel.text = _model.landlordPhone;
    self.addressLabel.text = _model.fullAddress;
    
    if (_model.operation == 10) {
        self.telLabel.userInteractionEnabled = YES;
        self.telLabel.textColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        [self.telLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telLabelTap)]];
    }else {
        self.telLabel.userInteractionEnabled = NO;
        self.telLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)telLabelTap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(telLabelEvent)]) {
        [self.delegate telLabelEvent];
    }
}

@end
