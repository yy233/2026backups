//
//  MyOrderModelSubCommodityModel.h
//  Community
//
//  Created by 余莹 on 2021/5/20.
//  订单数据里面 商铺列表的model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderModelSubCommodityModel : NSObject
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *goodsUuid;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *orderUuid;

 
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,assign) double price;



/**
 *             {
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
 */
@end

NS_ASSUME_NONNULL_END
