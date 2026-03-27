//
//  LifeCostPropertyFeeListLateUseInfoModelSubTypeModel.h
//  Community
//
//  Created by 余莹 on 2022/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPropertyFeeListLateUseInfoModelSubTypeModel : NSObject
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *orderNum;
@property (nonatomic,copy) NSString *overTime;
@property (nonatomic,copy) NSString *rise;
@property (nonatomic,assign) CGFloat totalMoney;
// 1.物业管理费、2.车辆管理费、3.电梯使用费
@property (nonatomic, assign) NSInteger pageType;
// 三方单号
@property (nonatomic, copy) NSString *tripartiteOrder;

@property (nonatomic,assign) BOOL isSelectedUIBool;//给UI用的 当前行的选择状态数据

@end

NS_ASSUME_NONNULL_END
