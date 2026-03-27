//
//  ZYVisitorInviteUploadModel.h
//  Community
//
//  Created by ZY on 2022/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYVisitorInviteUploadModel : NSObject

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 名称
@property (nonatomic, copy) NSString *name;

// 来访人联系方式
@property (nonatomic, copy) NSString *contact;

// 地址
@property (nonatomic, copy) NSString *address;

// 房屋ID
@property (nonatomic, copy) NSString *houseId;

// 单元ID
@property (nonatomic, copy) NSString *unitId;

// 来访事由ID 1.一般来访 2.应聘来访 3.走亲访友 4.客户来访
@property (nonatomic, assign) NSInteger reason;

// 来访事由文本
@property (nonatomic, copy) NSString *reasonStr;

// 来访开始时间
@property (nonatomic, copy) NSString *startTime;

// 来访结束时间
@property (nonatomic, copy) NSString *endTime;

@end

NS_ASSUME_NONNULL_END
