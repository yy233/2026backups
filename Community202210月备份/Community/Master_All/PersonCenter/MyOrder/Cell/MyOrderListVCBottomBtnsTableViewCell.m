//
//  MyOrderListVCBottomBtnsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderListVCBottomBtnsTableViewCell.h"

@interface MyOrderListVCBottomBtnsTableViewCell ()
@property (nonatomic,strong) MyOrderModel *orderModel;
@end

@implementation MyOrderListVCBottomBtnsTableViewCell

- (void)fillDataWithOrderModel:(MyOrderModel *)model{
    self.orderModel = model;
    DLog(@"");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bottomCellTypeUI:(MyOrderListCell_Type)cellType{
  
//    switch (cellType) {
//        case MyOrderListCell_Type_WillPay:
//            [self cellUpUIWillPay];
//            break;
//        case MyOrderListCell_Type_EndDeal:
//            [self cellUpUIEndDeal];
//            break;
//        case MyOrderListCell_Type_IsCancel:
//            [self cellUpUIIsCancel];
//            break;
//        case MyOrderListCell_Type_WillEvaluation:
//            [self cellUpUIWillEvaluation];
//            break;
//        case MyOrderListCell_Type_WillUse:
//            [self cellUpUIWillUse];
//            break;
//
//        default:
//
//            break;
//    }
    switch (cellType) {
        case  MyOrderListCell_Type_WillPay:
            [self cellUpUIWillPay];
            break;
//        case  MyOrderListCell_Type_EndDeal:
//            [self cellUpUIEndDeal];
//            break;
        case  MyOrderListCell_Type_ReturnCom:
            [self cellUpUIIsCancel];
            break;
        case  MyOrderListCell_Type_WillEvaluation:
            [self cellUpUIWillEvaluation];
            break;
        case  MyOrderListCell_Type_WillUse:
            [self cellUpUIWillUse];
            break;
        default:
            [self cellUpUIWillEvaluation];
            break;
    }
}
//待支付
- (void)cellUpUIWillPay{
    self.payBtn.hidden = NO;
    self.evaluationBtn.hidden = YES;
    self.onceAgainBtn.hidden = YES;
    self.refundScheduleBtn.hidden = YES;
}
//已完成
- (void)cellUpUIEndDeal{
    self.payBtn.hidden = YES;
    self.evaluationBtn.hidden = NO;
    self.onceAgainBtn.hidden = NO;
    self.refundScheduleBtn.hidden = YES;
    [_onceAgainBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_evaluationBtn.mas_left).offset(-10);
        make.centerY.width.height.equalTo(_evaluationBtn);
    }];
}
//已经取消
- (void)cellUpUIIsCancel{
    self.payBtn.hidden = YES;
    self.evaluationBtn.hidden = YES;
    self.onceAgainBtn.hidden = NO;
    self.refundScheduleBtn.hidden = YES;
    [_onceAgainBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_onceAgainBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_onceAgainBtn.superview.mas_centerY);
        make.width.offset(80);
        make.height.offset(30);
    }];
}
//待评价
- (void)cellUpUIWillEvaluation{
    self.payBtn.hidden = YES;
    self.evaluationBtn.hidden = NO;
    self.onceAgainBtn.hidden = YES;
    self.refundScheduleBtn.hidden = YES;
}
//待使用
- (void)cellUpUIWillUse{
    self.payBtn.hidden = YES;
    self.evaluationBtn.hidden = YES;
    self.onceAgainBtn.hidden = NO;
    self.refundScheduleBtn.hidden = YES;
    [_onceAgainBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_onceAgainBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_onceAgainBtn.superview.mas_centerY);
        make.width.offset(80);
        make.height.offset(30);
    }];
}
//退款进度
- (void)cellUpUiIsRefundSchedule{
    self.refundScheduleBtn.hidden = YES;
    self.payBtn.hidden = YES;
    self.evaluationBtn.hidden = YES;
    self.onceAgainBtn.hidden = NO;
    self.refundScheduleBtn.hidden = NO;
    [_onceAgainBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_refundScheduleBtn.mas_left).offset(-10);
        make.centerY.width.height.equalTo(_refundScheduleBtn);
    }];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.payBtn];
        [self.backView addSubview:self.evaluationBtn];
        [self.backView addSubview:self.onceAgainBtn];
        [self.backView addSubview:self.refundScheduleBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_payBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_payBtn.superview.mas_centerY);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_evaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_evaluationBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_evaluationBtn.superview.mas_centerY);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_onceAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_onceAgainBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_onceAgainBtn.superview.mas_centerY);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_refundScheduleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_refundScheduleBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_refundScheduleBtn.superview.mas_centerY);
        make.width.offset(80);
        make.height.offset(30);
    }];
    
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];
        [_payBtn newAnBtnWithTextStr:@"立即支付"];
        [_payBtn newAnBtnWithFont:FontSize_Orders_Bold(14)];
        [_payBtn newAnBtnWithTextColor:Color_102Gray];
        [_payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}
- (UIButton *)evaluationBtn{
    if (!_evaluationBtn) {
        _evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_evaluationBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];
        [_evaluationBtn newAnBtnWithTextStr:@"评价"];
        [_evaluationBtn newAnBtnWithFont:FontSize_Orders_Bold(14)];
        [_evaluationBtn newAnBtnWithTextColor:Color_102Gray];
        [_evaluationBtn addTarget:self action:@selector(evaluationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluationBtn;
}
- (UIButton *)onceAgainBtn{
    if (!_onceAgainBtn) {
        _onceAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onceAgainBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_onceAgainBtn newAnBtnWithTextStr:@"再来一单"];
        [_onceAgainBtn newAnBtnWithFont:FontSize_Orders_Bold(14)];
        [_onceAgainBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_onceAgainBtn addTarget:self action:@selector(onceAgainBtnAction) forControlEvents:UIControlEventTouchUpInside];
        //
        UIColor *beginColor =  Y_RGBA(38, 114, 249, 1);
        UIColor *endColor =  Y_RGBA(56, 128, 251, 1);
        CGSize size = CGSizeMake(80, 30);//h
        _onceAgainBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
    }
    return _onceAgainBtn;
}
- (UIButton *)refundScheduleBtn{
    if (!_refundScheduleBtn) {
        _refundScheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refundScheduleBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];
        [_refundScheduleBtn newAnBtnWithTextStr:@"退款进度"];
        [_refundScheduleBtn newAnBtnWithFont:FontSize_Orders_Bold(14)];
        [_refundScheduleBtn newAnBtnWithTextColor:Color_102Gray];
        [_refundScheduleBtn addTarget:self action:@selector(refundScheduleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refundScheduleBtn;
}

#pragma mark ===
- (void)payBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchPayBtnWithOrderModel:)]) {
        [_delegate touchPayBtnWithOrderModel:self.orderModel];
    }
}
- (void)evaluationBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchEvaluationBtnWithOrderModel:)]) {
        [_delegate touchEvaluationBtnWithOrderModel:self.orderModel];
    }
}
- (void)onceAgainBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchOnceAgainBtnWithOrderModel:)]) {
        [_delegate touchOnceAgainBtnWithOrderModel:self.orderModel];
    }
    
}
- (void)refundScheduleBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchRefundScheduleBtnWithOrderModel:)]) {
        [_delegate touchRefundScheduleBtnWithOrderModel:self.orderModel];
    }
}
@end
