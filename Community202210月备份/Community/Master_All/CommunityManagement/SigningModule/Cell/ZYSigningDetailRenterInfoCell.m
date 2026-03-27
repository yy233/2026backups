//
//  ZYSigningDetailRenterInfoCell.m
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import "ZYSigningDetailRenterInfoCell.h"

@interface ZYSigningDetailRenterInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *landlordTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *landlordTelLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYSigningDetailRenterInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.landlordTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
    if (_model.operation == 0) {
        self.topView.hidden = YES;
        CGRect bounds = CGRectMake(0, 0, kScreenW - 32, 80);
        [self.contentV cornerRadiusWithBounds:bounds radius:7.5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        self.nameTitleLabel.text = @"我的认证";
        self.telTitleLabel.text = @"我的电话";
    }else if (_model.operation == 7) {
        self.topView.hidden = NO;
        CGRect bounds = CGRectMake(0, 0, kScreenW - 32, 120);
        [self.contentV cornerRadiusWithBounds:bounds radius:7.5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        self.landlordTelLabel.text = _model.landlordPhone;
        self.nameTitleLabel.text = @"我的认证";
        self.telTitleLabel.text = @"我的电话";
        [self.landlordTelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(landlordTelLabelTap)]];
    }else if (_model.operation == 1 || _model.operation == 2 || _model.operation == 8 || _model.operation == 9 || _model.operation == 10) {
        if (_model.identityType == 1) {
            self.topView.hidden = YES;
            CGRect bounds = CGRectMake(0, 0, kScreenW - 32, 80);
            [self.contentV cornerRadiusWithBounds:bounds radius:7.5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            self.nameTitleLabel.text = @"申请人";
            self.telTitleLabel.text = @"电话";
        }
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", _model.realName, _model.tenantIdCard];
    self.telLabel.text = _model.tenantPhone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)landlordTelLabelTap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(landlordTelLabelEvent)]) {
        [self.delegate landlordTelLabelEvent];
    }
}

@end
