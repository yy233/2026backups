//
//  UserFamilyModel.h
//  Community
// 家属的model
//  Created by 余莹 on 2020/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserFamilyModel : NSObject
// 家属
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *deleted;
@property (nonatomic,strong) NSString *householderId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) NSInteger relation;
@end

NS_ASSUME_NONNULL_END


/**
 proprietorMembers =         (
                 {
         communityId = 1;
         createTime = "<null>";
         deleted = "<null>";
         houseId = 5;
         householderId = test123;
         id = 10;
         idCard = 513029199910053056;
         mobile = 15914158052;
         name = "余易";
         relation = 2;
         sex = 1;
         updateTime = "<null>";
     }*/
