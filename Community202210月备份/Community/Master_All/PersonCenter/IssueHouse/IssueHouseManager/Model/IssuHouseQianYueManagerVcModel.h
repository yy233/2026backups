//
//  IssuHouseQianYueManagerVcModel.h
//  Community
//
//  Created by 余莹 on 2021/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssuHouseQianYueManagerVcModel : NSObject

@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *homeOwnerUid;
@property (nonatomic,strong) NSString *houseType;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *tenantUid;
@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) NSInteger advantageId;
@property (nonatomic,assign) NSInteger assetId;
@property (nonatomic,assign) NSInteger assetType;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger contractNumber;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger directionId;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger operation;
@property (nonatomic,assign) NSInteger typeCode;

@property (nonatomic,assign) double price;

@property (nonatomic,strong) NSDictionary *houseAdvantageCode;

@property (nonatomic, assign) NSInteger readMark;



/**
 
 advantageId = 72;
 assetId = 68470000272412673;
 assetType = 2;
 communityId = 1;
 contractNumber = 1;
 createTime = "2021-09-02 11:16:05";
 deleted = 0;
 directionId = 1;
 homeOwnerUid = test123;
 houseAdvantageCode =                 {
     "地铁近" = 8;
     "电梯楼" = 64;
 };
 houseType = "1室0厅0卫";
 id = 96669666902151168;
 idStr = 96669666902151168;
 imageUrl = "http://222.178.212.29:9000/house-img/8be0e19cb45a4d1aae0787d4cc803f4d";
 operation = 1;
 price = 333;
 tenantUid = test123;
 title = "中渝都会附近大屋子出租先到先得";
 typeCode = 010000;s
 */
@end

NS_ASSUME_NONNULL_END
