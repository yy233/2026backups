//
//  MyHouseCerEdHouseModel.h
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//已经认证的房屋
@interface MyHouseCerEdHouseModel : NSObject
@property (nonatomic,strong) NSString *communityText;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,strong) NSString *houseSite;
@property (nonatomic,assign) NSInteger houseId;
/**
 {
 {
communityId = 1;
communityText = "帆软社区";
houseId = 91684044890312704;
houseSite = "1栋1单元1612";
}
 */
@end

//有关联的house
@interface MyHouseRelationMeAllTypeHouseModel : NSObject

@property (nonatomic,strong) NSString *communityText;
@property (nonatomic,strong) NSString *houseSite;
@property (nonatomic,strong) NSString *relationText;
@property (nonatomic,assign) NSInteger relation;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) NSInteger communityId;
/**
 {
 communityId = 1;
 communityText = "帆软社区";
 houseId = 91647786705096704;
 houseSite = "1栋1单元201";
 relation = 1;
 relationText = "业主";
}
 */
@end

NS_ASSUME_NONNULL_END
