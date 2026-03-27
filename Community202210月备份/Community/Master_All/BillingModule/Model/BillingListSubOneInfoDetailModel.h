//
//  BillingListSubOneInfoDetailModel.h
//  Community
//
//  Created by 余莹 on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillingListSubOneInfoDetailModel : NSObject
//
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *cno;
@property (nonatomic,strong) NSString *subHeadImgUrl;
@property (nonatomic,strong) NSString *subName;
@property (nonatomic,strong) NSString *subImId;
@property (nonatomic,assign) double amount;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *payTime;
@property (nonatomic,assign) NSInteger type;

//
@property (nonatomic,strong) NSString *tradeStateStr;
@property (nonatomic,strong) NSString *tradeName;
@property (nonatomic,strong) NSString *merchantName;
@property (nonatomic,strong) NSString *thirdOrderNo;
@property (nonatomic,strong) NSString *sysOrderNo;
/**
 列表子数据
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
 
 详情
 "sign": null,
     "data": {
         "tradeStateStr": "支付成功",
         "amount": "0.01",
         "cno": "CNY",
         "tradeName": "测试商品下单",
         "merchantName": "重庆纵横世纪科技有限公司",
         "payTime": "2022-06-08 15:56",
         "thirdOrderNo": "4200001495202206085390483264",
         "sysOrderNo": "39882022060815560272450654075903",
         "subHeadImgUrl": "http://222.178.212.29:9000/2021-09-04/c924cb0c4889407d806b7205ad35760d.png",
         "subName": "房屋管理",
         "subImId": "houseManage"
     }
 
 
 */
@end

NS_ASSUME_NONNULL_END
