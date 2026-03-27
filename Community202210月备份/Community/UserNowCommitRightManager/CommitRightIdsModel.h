//
//  CommitRightIdsModel.h
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommitRightIdsModel : NSObject
@property (nonatomic,assign) NSInteger accessLevel;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger houseId;

/**
 “accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
 “communityId”：小区id
 “houseId”：房间id
 
 */
@end

NS_ASSUME_NONNULL_END
