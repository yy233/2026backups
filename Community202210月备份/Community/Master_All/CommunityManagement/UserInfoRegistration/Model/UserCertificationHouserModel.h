//
//  UserCertificationHouserModel.h
//  Community
//
//  Created by 余莹 on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCertificationHouserModel : NSObject
@property (nonatomic,strong) NSString *communityName;
@property (nonatomic,strong) NSString *building;
@property (nonatomic,strong) NSString *unit;
@property (nonatomic,strong) NSString *floor;
@property (nonatomic,strong) NSString *door;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger houseId;//门牌ID
@property (nonatomic,assign) NSInteger id;//门牌id 改属性 为 条目ID

/**
 proprietorCars =         (
 );
 proprietorHouses =         (
                 {
         building = "2栋";
         communityId = 1;
         communityName = "帆云小区";
         door = "1-10";
         floor = "1层";
         houseId = 114;
         id = 777;
         unit = "2单元";
     },
 
 */
@end

NS_ASSUME_NONNULL_END
