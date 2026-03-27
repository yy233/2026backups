//
//  PackingPayHistoryModel.h
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackingPayHistoryModel : NSObject
@property (nonatomic,copy) NSString *carNumber;//车牌号
@property (nonatomic,copy) NSString *carPositionNumber;//车位号
@property (nonatomic,assign) NSInteger groundUpAndDown; //0地上1地下   地上展示车位号 地下展示车牌号
@property (nonatomic,copy) NSString *siteClassificationName; //场地分类名称
@property (nonatomic,assign) CGFloat payMoney;
@property (nonatomic,copy) NSString *payTime;
@property (nonatomic,assign) NSInteger payType;//支付方式 1微信 2支付宝 3现金
@property (nonatomic,copy) NSString *startTime;//开始时间
@property (nonatomic,copy) NSString *stopTime;//到期时间
@property (nonatomic,copy) NSString *systemNumber;//系统订单编号


@end

NS_ASSUME_NONNULL_END
