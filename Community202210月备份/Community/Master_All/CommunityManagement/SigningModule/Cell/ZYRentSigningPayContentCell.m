//
//  ZYRentSigningPayContentCell.m
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import "ZYRentSigningPayContentCell.h"

@interface ZYRentSigningPayContentCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentLabel;

@property (weak, nonatomic) IBOutlet UILabel *depositTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *depositLabel;

@property (weak, nonatomic) IBOutlet UILabel *leaseTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *leaseLabel;

@property (weak, nonatomic) IBOutlet UILabel *paymentTypeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;

@end

@implementation ZYRentSigningPayContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.payTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.rentTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.rentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.depositTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.depositLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.leaseTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.leaseLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.paymentTypeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.paymentTypeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYRentSigningPayModel *)model {
    _model = model;
    
    self.payLabel.text = [NSString stringWithFormat:@"￥%@", _model.totalPayment];
    self.rentLabel.text = [NSString stringWithFormat:@"￥%@", _model.roomRent];
    self.depositLabel.text = [NSString stringWithFormat:@"￥%@", _model.deposit];
    self.leaseLabel.text = [NSString stringWithFormat:@"%ld天", _model.leaseTerm];
    self.paymentTypeLabel.text = _model.paymentType;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
