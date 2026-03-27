//
//  ZYRentContractDetailBottomView.m
//  Community
//
//  Created by ZY on 2021/8/21.
//

#import "ZYRentContractDetailBottomView.h"

@interface ZYRentContractDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIView *statusView;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UIView *cochainFinishView;

@property (weak, nonatomic) IBOutlet UIButton *depositCertificateButton;

@property (weak, nonatomic) IBOutlet UIButton *downloadContractButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYRentContractDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
    if (_model.operation == 6) {
        if (_model.blockStatus == 4) {
            self.cochainFinishView.hidden = NO;
            self.statusView.hidden = YES;
            [self.depositCertificateButton addTarget:self action:@selector(depositCertificateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.downloadContractButton addTarget:self action:@selector(downloadContractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }else {
            self.cochainFinishView.hidden = YES;
            self.statusView.hidden = NO;
            [self.statusButton setTitle:@"区块链司法存证上链中..." forState:UIControlStateNormal];
            self.statusButton.tag = 200 + _model.operation;
            [self.statusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        self.cochainFinishView.hidden = YES;
        self.statusView.hidden = NO;
        if (_model.operation == 32) {
            [self.statusButton setTitle:@"重新发起" forState:UIControlStateNormal];
        }else {
            [self.statusButton setTitle:@"取消发起" forState:UIControlStateNormal];
        }
        self.statusButton.tag = 200 + _model.operation;
        [self.statusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 点击事件
- (void)depositCertificateButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(depositCertificateButtonClickedEvent)]) {
        [self.delegate depositCertificateButtonClickedEvent];
    }
}

- (void)downloadContractButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadContractButtonClickedEvent)]) {
        [self.delegate downloadContractButtonClickedEvent];
    }
}

- (void)statusButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    if (self.delegate && [self.delegate respondsToSelector:@selector(statusButtonEventWithIndex:)]) {
        [self.delegate statusButtonEventWithIndex:index];
    }
}

@end
