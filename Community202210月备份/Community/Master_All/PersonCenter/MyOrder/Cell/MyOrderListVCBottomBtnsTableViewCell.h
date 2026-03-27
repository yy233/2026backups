//
//  MyOrderListVCBottomBtnsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListVCBottomBtnsTableViewCell : MyOrderListVcBaseTableViewCell
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIButton *evaluationBtn;
@property (nonatomic,strong) UIButton *onceAgainBtn;
@property (nonatomic,strong) UIButton *refundScheduleBtn;//退款进度
- (void)bottomCellTypeUI:(MyOrderListCell_Type)cellType;
@property (nonatomic,weak) id <MyOrderListVcCellDelegate> delegate;
//待支付
- (void)cellUpUIWillPay;
//已完成
- (void)cellUpUIEndDeal;
//已经取消
- (void)cellUpUIIsCancel;
//待评价
- (void)cellUpUIWillEvaluation;
//待使用
- (void)cellUpUIWillUse;
//退款进度
- (void)cellUpUiIsRefundSchedule;

- (void)fillDataWithOrderModel:(MyOrderModel *)model;
@end

NS_ASSUME_NONNULL_END
