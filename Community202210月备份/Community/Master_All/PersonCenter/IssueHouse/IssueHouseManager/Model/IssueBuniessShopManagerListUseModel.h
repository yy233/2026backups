//
//  IssueBuniessShopManagerListUseModel.h
//  Community
//
//  Created by 余莹 on 2021/3/25.
// 商铺管理页 发布房源的list

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueBuniessShopManagerListUseModel : NSObject
 
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *defrayType;
@property (nonatomic,strong) NSString *floor;
@property (nonatomic,strong) NSString *shopShowImg;
@property (nonatomic,strong) NSString *summarize;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *statusString;
@property (nonatomic,strong) NSString *shopType;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *address;

@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger freeLease;
@property (nonatomic,assign) NSInteger startLease;//起租期
@property (nonatomic,assign) NSInteger shopTypeId;
@property (nonatomic,assign) NSInteger source;

@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger shopPeople;
@property (nonatomic,assign) NSInteger shopBusinessId;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
@property (nonatomic,assign) double monthMoney;
@property (nonatomic,assign) double shopAcreage;
@property (nonatomic,assign) double shopDepth;
@property (nonatomic,assign) double shopHeight;
@property (nonatomic,assign) double shopWidth;
@property (nonatomic,assign) double transferMoney;
 
/**
 
 area = "\U6e1d\U4e2d\U533a";
 areaId = 500103;
 city = "\U91cd\U5e86\U5e02";
 cityId = 500100;
 communityId = 4;
 createTime = "2021-03-05 16:43:50";
 defrayType = "\U62bc1\U4ed83";
 deleted = 0;
 floor = "1\U5c42/\U51711\U5c42";
 freeLease = 0;
 id = 31159944598392832;
 idStr = 31159944598392832;
 lat = 0;
 lon = 0;
 mobile = 18880099800;
 monthMoney = 2222;
 nickname = "\U540d\U5b57";
 shopAcreage = 90;
 shopBusinessId = 0;
 shopDepth = 1;
 shopFacility = 524;
 shopHeight = 1;
 shopPeople = 4;
 shopShowImg = "http://222.178.212.29:9000/shop-head-img/b4986d0a-9980-494c-accb-c6bd16ed5681";
 shopTypeId = 1;
 shopWidth = 1;
 source = 1;
 startLease = 3;
 status = 0;
 statusString = "\U7a7a\U7f6e\U4e2d";
 summarize = "\U63cf\U8ff02";
 title = "\U63cf\U8ff01";
 transferMoney = 33333;
 uid = test123;
}
 */
@end

NS_ASSUME_NONNULL_END
