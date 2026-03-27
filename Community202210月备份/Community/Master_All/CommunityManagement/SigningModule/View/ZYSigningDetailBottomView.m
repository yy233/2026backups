//
//  ZYSigningDetailBottomView.m
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import "ZYSigningDetailBottomView.h"

@interface ZYSigningDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIView *signingView;

@property (weak, nonatomic) IBOutlet UIButton *againButton;

@property (weak, nonatomic) IBOutlet UIView *refuseView;

@property (weak, nonatomic) IBOutlet UIView *refuseLineView;

@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (weak, nonatomic) IBOutlet UIView *acceptView;

@property (weak, nonatomic) IBOutlet UIView *acceptLineView;

@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

@end

@implementation ZYSigningDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.refuseView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.refuseLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    [self.refuseButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
    if (_model.operation == 0) {
        self.signingView.hidden = NO;
        self.againButton.hidden = YES;
        self.refuseView.hidden = YES;
        self.acceptView.hidden = YES;
        [self.signingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signingViewTap)]];
    }else if (_model.operation == 1 || _model.operation == 9) {
        if (_model.identityType == 1) {
            self.signingView.hidden = YES;
            self.againButton.hidden = YES;
            self.refuseView.hidden = NO;
            self.acceptView.hidden = NO;
            [self.refuseButton addTarget:self action:@selector(refuseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.acceptButton addTarget:self action:@selector(acceptButtonnClicked) forControlEvents:UIControlEventTouchUpInside];
        }else {
            self.signingView.hidden = YES;
            self.againButton.hidden = NO;
            self.refuseView.hidden = YES;
            self.acceptView.hidden = YES;
            self.againButton.tag =  300 + _model.operation;
            [self.againButton setTitle:@"取消签约" forState:UIControlStateNormal];
            [self.againButton addTarget:self action:@selector(againButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        self.signingView.hidden = YES;
        self.againButton.hidden = NO;
        self.refuseView.hidden = YES;
        self.acceptView.hidden = YES;
        if (_model.operation == 2  || _model.operation == 32) {
            if (_model.identityType == 1) {
                [self.againButton setTitle:@"拟定合同" forState:UIControlStateNormal];
            }else {
                self.hidden = YES;
            }
        }else if (_model.operation == 4 || _model.operation == 5 || _model.operation == 31) {
            if (_model.identityType == 2) {
                [self.againButton setTitle:@"签约合同" forState:UIControlStateNormal];
            }else {
                self.hidden = YES;
            }
        }else if (_model.operation == 6) {
            if (_model.identityType == 1) {
                self.hidden = YES;
            }else {
                [self.againButton setTitle:@"查看合同" forState:UIControlStateNormal];
            }
        }else if (_model.operation == 8) {
            if (_model.identityType == 1) {
                self.hidden = YES;
            }else {
                [self.againButton setTitle:@"再次申请" forState:UIControlStateNormal];
            }
        }else if (_model.operation == 7) {
            if (_model.identityType == 2) {
                [self.againButton setTitle:@"重新发起" forState:UIControlStateNormal];
            }else {
                self.hidden = YES;
            }
        }else if (_model.operation == 10) {
            self.hidden = YES;
        }
        self.againButton.tag =  300 + _model.operation;
        [self.againButton addTarget:self action:@selector(againButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 发起签约
- (void)signingViewTap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(signingViewTapEvent)]) {
        [self.delegate signingViewTapEvent];
    }
}

// 拒绝申请
- (void)refuseButtonClicked {

    if (self.delegate && [self.delegate respondsToSelector:@selector(refuseButtonClickedEvent)]) {
        [self.delegate refuseButtonClickedEvent];
    }
}

// 接受申请
- (void)acceptButtonnClicked {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(acceptButtonnClickedEvent)]) {
        [self.delegate acceptButtonnClickedEvent];
    }
}

// 确认
- (void)againButtonClicked:(UIButton *)sender {
    
    NSInteger index = sender.tag - 300;
    if (self.delegate && [self.delegate respondsToSelector:@selector(againButtonClickedEventWithIndex:)]) {
        [self.delegate againButtonClickedEventWithIndex:index];
    }
}

@end
