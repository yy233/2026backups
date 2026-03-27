//
//  ZYSigningDetailTopCell.m
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import "ZYSigningDetailTopCell.h"

@interface ZYSigningDetailTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *sendView;

@property (weak, nonatomic) IBOutlet UIView *sendLineView;

@property (weak, nonatomic) IBOutlet UILabel *signingTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *signingView;

@property (weak, nonatomic) IBOutlet UIView *signingLineView;

@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UIView *payLineView;

@property (weak, nonatomic) IBOutlet UILabel *completeTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *completeView;

@property (weak, nonatomic) IBOutlet UIView *completeLineView;

@end

@implementation ZYSigningDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
    if (_model.operation == 0) {
        self.titleLabel.text = @"在线签约 保障住房权益";
    }else if (_model.operation == 1 || _model.operation == 9) {
        if (_model.identityType == 1) {
            self.titleLabel.text = @"在线签约 保障住房权益";
        }else {
            self.titleLabel.text = @"等待房东确认";
        }
    }else if (_model.operation == 2) {
        if (_model.identityType == 1) {
            self.titleLabel.text = @"您已接受此次申请";
        }else {
            self.titleLabel.text = @"等待房东拟定合同";
        }
    }else if (_model.operation == 4 || _model.operation == 5 || _model.operation == 31 || _model.operation == 32) {
        self.titleLabel.text = @"在线签约 保障住房权益";
    }
    
    if (_model.operation == 0 || _model.operation == 1 || _model.operation == 9) {
        self.sendTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.sendView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.sendLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        self.signingView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.signingLineView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.payTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        self.payView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.payLineView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.completeTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        self.completeView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.completeLineView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
    }else if (_model.operation == 2 || _model.operation == 4 || _model.operation == 31 || _model.operation == 32) {
        self.sendTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.sendView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.sendLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.signingView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.payTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        self.payView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.payLineView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.completeTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        self.completeView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.completeLineView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
    }else if (_model.operation == 5) {
        self.sendTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.sendView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.sendLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.signingView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.payTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.payView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.payLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.completeTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        self.completeView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
        self.completeLineView.backgroundColor = [ZYThemeManager shareManager].lineViewBackgroundThemeColor;
    }else if (_model.operation == 6) {
        self.sendTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.sendView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.sendLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.signingView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.signingLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.payTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.payView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.payLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.completeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L2672f9;
        self.completeView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        self.completeLineView.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
