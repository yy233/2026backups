//
//  LifeCostData.h
//  Community
//
//  Created by 余莹 on 2022/1/4.
//

#import <Foundation/Foundation.h>

#import "LifeCostSaveCityInfoModel.h"
#import "LifeCostPayTypeModel.h"
#import "LifeCostPayHistoryOrderListModel.h"
#import "LifeCostPayHistoryOrderSubOrderEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^LifeCostSaveCityInfoBlock)(NSString *saveNowCityName,BOOL success);

@interface LifeCostData : NSObject
#pragma mark === 主页
//主页 户号列表
+ (void)lifeCostGetMainWithMinHuHaoSectionListWithArrBlcok:(BaseListArrAndSuccessBoolBlock)block;
//新增缴费相关
+ (void)lifeCostGetMainWithPayTypeListWithArrBlock:(BaseListArrAndSuccessBoolBlock)payTypeListblock;
//查询缴费类别
+ (void)lifeCostGetOneCity:(NSString *)cityNameStr withPayTypeListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block;

//主页 某种缴费类别 点击跳转市调用本接口 拿到类型数据 做不同界面的跳转。 查询缴费项目
+ (void)lifeCostGetOneCityAddGoToVcTypeWithCityPayTypeNum:(NSInteger)cityType withCityName:(NSString *)cityNameStr withCostProjectListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block;
#pragma mark === 切换城市 相关处理
+ (void)lifeCostChangeCityWithChooseNameStr:(NSString *)changeNameStr withGetNewPayTypeListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block;

#pragma mark === 历史 缴费记录相关

#pragma mark == 历史 缴费记录 列表
//初始查
+ (void)lifeCostGetPayOrderListWithPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block;
//分类型查
+ (void)lifeCostGetPayOrderListWithTypeIdStr:(NSString *)typeIdStr withPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block;
//用时间查
+ (void)lifeCostGetPayOrderListWithQueryTimeStr:(NSString *)queryTimeStr withPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block;
//类型+时间
+ (void)lifeCostGetPayOrderListWithTypeIdStr:(NSString *)typeIdStr
                                andQueryTimeStr:(NSString *)queryTimeStr
                withPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block;

#pragma mark == 历史 缴费记录 详情
+ (void)lifeCostGetPayHistoryOrderDetailWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block;

#pragma mark == 缴费公司列表查询
+ (void)lifeCostGetPayCompanyListWithTypeIdStr:(NSString *)typeIdStr
                               andCityNameStr:(NSString *)cityNameStr
                              andSearchTextStr:(NSString *)searchTextStr
               withCompanyListBlock:(BaseListArrAndSuccessBoolBlock)block;


#pragma mark == 待支付 账单列表
+ (void)lifeCostGetWillPayOrderListWithMyAccoundBillKeyStr:(NSString *)billKeyStr withListBlock:(BaseListArrAndSuccessBoolBlock)block;
#pragma mark == 待支付 账单详情
+ (void)lifeCostGetWillPayOrderDetailWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block;
#pragma mark == 待支付 直缴详情 （手机号缴费）
+ (void)lifeCostGetWillPayOrderDetailWithPayTypeId:(NSString *)payTypeIdStr withPhotoNumStr:(NSString *)photoNumStr withBlock:(BaseDicAndSuccessBoolBlock)block;

#pragma mark == 立即缴费
+ (void)lifeCostPayOrderActionWithBodyDic:(NSMutableDictionary *)bodyDic withDlock:(BaseDicAndSuccessBoolBlock)block;

#pragma mark == 在h5调用微信等app 缴完费或者放弃缴费后 (回到本app) 做查询当前订单状态信息 得到状态 用于跳转后续的成功失败界面
+ (void)lifeCostCheckOrderNoStr:(NSString *)orderNoStr withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
