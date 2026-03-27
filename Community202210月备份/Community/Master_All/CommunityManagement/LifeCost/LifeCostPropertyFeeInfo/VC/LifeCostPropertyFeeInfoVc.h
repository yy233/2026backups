//
//  LifeCostPropertyFeeInfoVc.h
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPropertyFeeInfoVc : BaseViewController
@property (nonatomic,assign) BOOL isDidPay;//orderStatus 未交no=0 已经缴纳yes=1 。未缴  那么就id就传数据id，1表示已缴那么id就传tripartiteOrder三方单号；
@property (nonatomic,strong) NSString *idStr;
@end

NS_ASSUME_NONNULL_END
