//
//  HouseRentListVcBuniessShopCellModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentListVcBuniessShopCellModel : NSObject
@property (nonatomic,assign) NSInteger communityId;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) double shopAcreage;//面积
@property (nonatomic,assign) double monthMoney;//钱 商铺的固定一月为单位 《弃用》
@property (nonatomic,strong) NSString *monthMoneyString;//钱 带单位的钱str
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *summarize;//详细文本  （弃用 改用详细地址）
@property (nonatomic,strong) NSString *imgPath;
@property (nonatomic,strong) NSArray *tags;//type

/**
            
 records =         (
                 {
         communityId = 1;
         id = 7583622206984192;
         imgPath = "1.png";
         monthMoney = 4000;
         shopAcreage = 135;
         summarize = "所有设施齐全，适合业态，便利店，小超市，有烟道，厨房卫生间齐全";
         tags =                 (
             "商业街店铺",
             "写字楼配套",
             "社区底商",
             "餐饮美食",
             "美容美发",
             "服饰鞋包",
             "休闲娱乐"
         );
         title = "草天门一楼临街门面，人流量不用说，租金便宜";
         uid = d09bb8bac4fe442f8826a8c329c9cf2a;
     },
                 {
         communityId = 1;
         id = 7583622206984192;
 */
@end

NS_ASSUME_NONNULL_END
