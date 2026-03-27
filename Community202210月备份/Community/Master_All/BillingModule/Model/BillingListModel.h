//
//  BillingListModel.h
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import <Foundation/Foundation.h>
#import "BillingListSubOneInfoDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillingListModel : NSObject
//当月基础信息
@property (nonatomic,strong) NSString *timeStr;
@property (nonatomic,assign) double payTotalAmount;
@property (nonatomic,assign) double payeeTotalAmount;
//数组 内有单个子信息
@property (nonatomic,strong) NSArray *balanceChanges;

/**
 
 "childData": [
             {
                 "timeStr": "2022年07月",
                 "payTotalAmount": "0.02",
                 "payeeTotalAmount": "0.00",
                 "balanceChanges": [
                     {
                         "id": 1534439530059526145,
                         "uid": 1471041123890466817,
                         "cno": "CNY",
                         "type": 2,
                         "subHeadImgUrl": "http://222.178.212.29:9000/2021-09-04/c924cb0c4889407d806b7205ad35760d.png",
                         "subName": "房屋管理",
                         "subImId": "houseManage",
                         "amount": "0.01",
                         "remark": "测试商品下单",
                         "title": "测试商品下单",
                         "createTime": "2022-07-01 15:37:47",
                         "payTime": "07月01日 15:37"
                     },
                     {
 
 */
@end

NS_ASSUME_NONNULL_END
