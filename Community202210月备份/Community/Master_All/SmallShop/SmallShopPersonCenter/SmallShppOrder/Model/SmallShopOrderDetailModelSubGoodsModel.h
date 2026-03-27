//
//  SmallShopOrderDetailModelSubGoodsModel.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopOrderDetailModelSubGoodsModel : NSObject
@property (nonatomic,copy) NSString  *storeId;
@property (nonatomic,copy) NSString  *orderId;

@property (nonatomic,copy) NSString  *serveHeadImg;
@property (nonatomic,copy) NSString  *serveId;
@property (nonatomic,copy) NSString  *serveName;
@property (nonatomic,copy) NSString  *serveNumber;
@property (nonatomic,copy) NSString  *serveSellPrice;

@property (nonatomic,copy) NSString  *commodityHeadImg;
@property (nonatomic,copy) NSString  *commodityId;
@property (nonatomic,copy) NSString  *commodityName;
@property (nonatomic,copy) NSString  *commodityNumber;
@property (nonatomic,copy) NSString  *commoditySellPrice;

/***
 
 商品
 {
commodityHeadImg = "https://img14.360buyimg.com/n0/jfs/t1/209741/7/408/76209/613efc51Efc78cc2f/59c7514ebb99f814.jpg";
commodityId = 1500719260448886786;
commodityName = "炸渝";
commodityNumber = 1;
commoditySellPrice = 20;
orderId = 1498867333884018692;
storeId = 1499661567331446785;
}
 
 服务
 
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
@end

NS_ASSUME_NONNULL_END
