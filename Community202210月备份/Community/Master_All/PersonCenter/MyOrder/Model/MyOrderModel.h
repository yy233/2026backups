//
//  MyOrderModel.h
//  Community
//
//  Created by 余莹 on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "MyOrderModelSubCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderModel : NSObject
@property (nonatomic,assign) NSInteger appStateNum;
@property (nonatomic,strong) NSString *appState;//订单状态文本

@property (nonatomic,strong) NSString *activityUuid;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *evaluationId;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *orderMessage;
@property (nonatomic,strong) NSString *orderNum;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *redpacketUuid;
@property (nonatomic,strong) NSString *serviceTime;
@property (nonatomic,strong) NSString *shopGoodsIds;
@property (nonatomic,strong) NSString *shopLogo;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *shopSent;
@property (nonatomic,strong) NSString *shopUuid;
@property (nonatomic,strong) NSString *shopPhone;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *userUuid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *uuid;


@property (nonatomic,assign) NSInteger deliveryFee;
@property (nonatomic,assign) NSInteger deliveryWay;
@property (nonatomic,assign) NSInteger id;
//@property (nonatomic,assign) NSInteger orderOriginalPrice;
@property (nonatomic,assign) NSInteger payState;
@property (nonatomic,assign) NSInteger serviceCode;
@property (nonatomic,assign) NSInteger stateId;
//@property (nonatomic,assign) NSInteger subtractPrice;
@property (nonatomic,assign) NSInteger used;

@property (nonatomic,assign) double orderPrice;//订单总价格
@property (nonatomic,assign) double orderOriginalPrice;//订单原价
@property (nonatomic,assign) double subtractPrice;//优惠了多少钱

@property (nonatomic,strong) NSArray<MyOrderModelSubCommodityModel *> *orderCommodityDtos; //MyOrderModelSubCommodityModel
 


/**
 orderMessage = "";
 orderNum = "2021-05-17-456799532";
 orderOriginalPrice = 37;
 orderPrice = 37;
 payState = 1;
 phone = 1888888880;
 redpacketUuid = "";
 serviceCode = 2873162021;
 serviceTime = "<null>";
 shopGoodsIds = "<null>";
 shopLogo = "2020-12-09/fb687c1e-7b53-4492-9cfa-09cc0ceb7c71-a.jpg";
 shopName = "\U5c0a\U5b9d\U5339\U8428";
 shopSent = "<null>";
 shopUuid = 1eef1c6c6cef46ffa76e3b1141cd02df;
 stateId = 1;
 subtractPrice = 8;
 updateTime = "2021-05-20 15:22:17";
 used = 0;
 userUuid = test123;
 username = "\U4f59";
 uuid = "<null>";
 
 //
 {
activityUuid = "<null>";
address = "\U5730\U5740111111111-8";
createTime = "2021-05-17 11:04:34";
deliveryFee = 0;
deliveryWay = 1;
evaluationId = "-1";
id = 270;
money = "<null>";
orderCommodityDtos =             (
                 {
     createTime = "<null>";
     goodsUuid = "<null>";
     id = 270;
     image = "2020-12-09/56b84cb7-3754-43ef-b9d3-3ef46777b3cb-ghhg.jpg";
     name = "\U9e21\U817f";
     num = 3;
     orderUuid = 108d03d636824d76b053e6a1e678c86c;
     price = 8;
 },
                 {
     createTime = "<null>";
     goodsUuid = "<null>";
     id = 270;
     image = "2020-12-09/2051d5d2-dcc2-4dba-92ef-5f917796db9a-gf.jpg";
     name = "\U9e21\U516c\U7172";
     num = 1;
     orderUuid = 108d03d636824d76b053e6a1e678c86c;
     price = 12;
 },
                 {
     createTime = "<null>";
     goodsUuid = "<null>";
     id = 270;
     image = "2020-12-09/bb5be2f6-cbb9-42b6-bbf1-12fac335ddef-fsd.jpg";
     name = "\U9ec4\U7116\U9e21";
     num = 2;
     orderUuid = 108d03d636824d76b053e6a1e678c86c;
     price = 12;
 }
);
orderMessage = "";
orderNum = "2021-05-17-456799532";
orderOriginalPrice = 37;
orderPrice = 37;
payState = 1;
phone = 1888888880;
redpacketUuid = "";
serviceCode = 2873162021;
serviceTime = "<null>";
shopGoodsIds = "<null>";
shopLogo = "2020-12-09/fb687c1e-7b53-4492-9cfa-09cc0ceb7c71-a.jpg";
shopName = "\U5c0a\U5b9d\U5339\U8428";
shopSent = "<null>";
shopUuid = 1eef1c6c6cef46ffa76e3b1141cd02df;
stateId = 1;
subtractPrice = 8;
updateTime = "2021-05-20 15:22:17";
used = 0;
userUuid = test123;
username = "\U4f59";
uuid = "<null>";
}
 */
@end

NS_ASSUME_NONNULL_END
