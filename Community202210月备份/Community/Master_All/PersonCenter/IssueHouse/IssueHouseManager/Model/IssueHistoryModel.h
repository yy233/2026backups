//
//  IssueHistoryModel.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHistoryModel : NSObject
@property (nonatomic,assign) double acreage;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,strong) NSString *houseImage;
@property (nonatomic,strong) NSString *browseTitle;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *leaseType;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSString *createTime;
//
/** house
 acreage = 124;
 address = "渝铁家苑(一二期)  (渝北 龙头寺)";
 browseTitle = "帆云小区 便宜出租 便宜出租!";
 createTime = "2021-02-19 17:00:59";
 houseId = 2536298372009984;
 houseImage = "http://222.178.212.29:9000/house-lease-img/4e32e40272caa70e506fcc469563cdf3c39046e29fd76ce402570060b28a4beb";
 leaseType = "整租";
 price = "15000/年";
 tag = "临街门面,商业街,地铁近";
 ---------
 buniessShop
     acreage = 135;
     address = "渝中区  帆软社区";
     browseTitle = "中国大陆几乎所有的中文系统和国际化的软件都";
     createTime = "2021-02-19 17:01:13";
     houseId = 18494565707288576;
     houseImage = "http://222.178.212.29:9000/shop-head-img/08602ee8ab9ffa13a93a02758cc4a6fbbfc68b4f3da80842b916339e7fe2a276";
     price = "44990.00/月";
     tag = "客梯,停车位,货梯";
 */
@end

NS_ASSUME_NONNULL_END
