//
//  ZYSigningDetailTopCancelCell.m
//  Community
//
//  Created by ZY on 2021/8/20.
//

#import "ZYSigningDetailTopCancelCell.h"

@interface ZYSigningDetailTopCancelCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ZYSigningDetailTopCancelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
    if (_model.operation == 7) {
        self.titleLabel.text = @"签约已取消";
        self.subTitleLabel.text = @"您已取消签约申请";
    }else if (_model.operation == 8) {
        self.titleLabel.text = @"您已拒绝此次申请";
        self.subTitleLabel.text = @"去与申请方说说原因吧";
    }else if (_model.operation == 10) {
        self.titleLabel.text = @"签约超时已失效";
        if (_model.identityType == 1) {
            self.subTitleLabel.text = @"请联系租客重新发起签约申请";
        }else {
            self.subTitleLabel.text = @"请与房东联系并重新发起签约申请";
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
