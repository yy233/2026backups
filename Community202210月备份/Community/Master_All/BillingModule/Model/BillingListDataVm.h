//
//  BillingListDataVm.h
//  Community
//
//  Created by 余莹 on 2022/6/9.
//

#import "BaseDataViewModel.h"


//账单类型 1收入 2支出 5充值 6提现 7退款-收入 8退款-支出
typedef enum : NSUInteger {
    BillingList_Type_Add,
    BillingList_Type_Delet,
    BillingList_Type_ChongZhi,
    BillingList_Type_Tixian,
    BillingList_Type_TuiKuan,
    BillingList_Type_ZhiChu,
} BillingList_Type;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ThisMountBillingListInfoGetAllMoneyBlock)(NSString *payTotalAmountStr);

@interface BillingListDataVm : BaseDataViewModel

- (void)fillQueryTimeStr:(NSString *)queryTimeStr andType:(NSInteger)type;

@property (nonatomic,copy) ThisMountBillingListInfoGetAllMoneyBlock moneyStrBlock;
@end

NS_ASSUME_NONNULL_END
