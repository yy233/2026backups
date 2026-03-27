//
//  SmallShopCartListModel.h
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import <Foundation/Foundation.h>
#import "SmallShopCartSubPayDtoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopCartListModel : NSObject
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger storeId;
@property (nonatomic,assign) NSInteger  type;//库存状态是否正常 1正常 0不正常   当购物车数量>库存数量时  库存状态为不正常
@property (nonatomic,assign) NSInteger  commodityNumber;
@property (nonatomic,assign) NSInteger  commodityRepertory;//库存数量
@property (nonatomic,copy) NSString *commodityHeadImg;
@property (nonatomic,copy) NSString *commodityName;



@property (nonatomic,strong) SmallShopCartSubPayDtoModel *payDto; //要可更改的 


/**
 {
commodityHeadImg = "\U9996\U56fe";
commodityId = 1498867333884018689;
commodityName = "\U70b8\U9e21";
commodityNumber = 1;
commodityRepertory = 100;
id = 1498867333884018689;
payDto =             {
 activityFull = "<null>";
 activityGive = "<null>";
 activityName = "<null>";
 activityType = 0;
 actualNumber = 1;
 actualPrice = 20;
 commodityId = 1498867333884018689;
 commodityOriginalPrice = 39;
 commoditySellPrice = 20;
 sumMoney = 20;
};
storeId = 1498534868334215170;
type = 1;
},
 {
commodityHeadImg = "\U9996\U56fe";
 */
@end

NS_ASSUME_NONNULL_END
