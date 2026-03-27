//
//  SmallShopOrderDetailModel.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <Foundation/Foundation.h>
#import "SmallShppOrderModel.h"
#import "SmallShopOrderDetailModelSubGoodsModel.h"
#import "SmallShopOrderDetailModelSubOrderModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SmallShopOrderDetailModel : NSObject
//非货柜用的key
/***
 
 data =     {
     size = 2;
     value0 =         (
                     {
             orderId = 165203043829288960;
             serveHeadImg = "服务门头图";
             serveId = 1498586891612160002;
             serveName = "一小时按摩";
             serveNumber = 1;
             serveSellPrice = 188;
             storeId = 1498555954903908353;
         }
     );
     value1 =         {
         orderNumber = 12345622222222222222;
         orderPayMoney = 188;
         orderTime = "2022-03-10T14:03:16";
     };
 };
 message = "根据
 */
@property (nonatomic,copy) NSArray  *value0;//商品信息 goodsOrSever Arr
@property (nonatomic,strong) SmallShopOrderDetailModelSubOrderModel  *value1;//订单信息

/** 货柜用的 key
 "userId": 1469119899337695200,//用户id
     "orderNumber": "220309115758724195106",//订单号
     "orderTime": "2022-03-09T11:57:59",//创建时间
     "orderPayMoney": 9.9,//支付金额
     "title": "标题",//智能柜名称
     "cabinetId": 1498593337188675600,
     "cabinetNumber": null,//智能柜编号
     "cabinetSize": 20，智能柜尺寸
     "cabinetImg": "http：//12346.jpg",
     "cabinetPriceStatus": 1,收费标准(1月租 2季度 3半年 4年度)
     "cabinetPriceSell": 9.9//售价~~~~
     "orderAddress": "重庆市俩江新区天宫殿社区17-20-1",//用户地址
     "userPhone": "13132321490"//用户电话
 code = 200;
 data =     {
     cabinetId = 1498593337188675585;
     cabinetImg = "https://img14.360buyimg.com/n0/jfs/t1/209741/7/408/76209/613efc51Efc78cc2f/59c7514ebb99f814.jpg";
     cabinetNumber = 1234562;
     cabinetPriceSell = "9.9";
     cabinetPriceStatus = 1;
     cabinetSize = 20;
     orderAddress = "重庆市俩江新区天宫殿社区17-20-1";
     orderNumber = 220309115758724195106;
     orderPayMoney = "9.9";
     orderTime = "2022-03-09T11:57:59";
     title = "标题";
     userId = 1492375926661103617;
     userPhone = 13132321490;
 };
 message = "查询成功";*/
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *orderNumber;
@property (nonatomic,copy) NSString *orderTime;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *cabinetId;
@property (nonatomic,copy) NSString *cabinetNumber;
@property (nonatomic,copy) NSString *cabinetImg;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString *orderAddress;
@property (nonatomic,copy) NSString *cabinetPriceOriginal;//原价
@property (nonatomic,copy) NSString *cabinetPriceSell;//售价
@property (nonatomic,copy) NSString *orderPayMoney;//支付金额
@property (nonatomic,assign) NSInteger cabinetPriceStatus;//收费标准(1月租 2季度 3半年 4年度)
@property (nonatomic,assign) NSInteger cabinetSize;
@end

NS_ASSUME_NONNULL_END
