//
//  ZYLifeCostPaymentAgreementCell.m
//  Community
//
//  Created by ZY on 2022/1/11.
//

#import "ZYLifeCostPaymentAgreementCell.h"

@interface ZYLifeCostPaymentAgreementCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label12;
@property (weak, nonatomic) IBOutlet UILabel *label13;
@property (weak, nonatomic) IBOutlet UILabel *label14;
@property (weak, nonatomic) IBOutlet UILabel *label15;
@property (weak, nonatomic) IBOutlet UILabel *label16;
@property (weak, nonatomic) IBOutlet UILabel *label17;
@property (weak, nonatomic) IBOutlet UILabel *label18;
@property (weak, nonatomic) IBOutlet UILabel *label19;
@property (weak, nonatomic) IBOutlet UILabel *label20;
@property (weak, nonatomic) IBOutlet UILabel *label21;
@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UILabel *label23;
@property (weak, nonatomic) IBOutlet UILabel *label24;
@property (weak, nonatomic) IBOutlet UILabel *label25;
@property (weak, nonatomic) IBOutlet UILabel *label26;

@end

@implementation ZYLifeCostPaymentAgreementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentViewWidthConstraint.constant = kScreenW;
    self.label1.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label2.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label3.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label4.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label5.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label6.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label7.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label8.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label9.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label10.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label11.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label12.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label13.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label14.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label15.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label16.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label17.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label18.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label19.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label20.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label21.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label22.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label23.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label24.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label25.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.label26.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
