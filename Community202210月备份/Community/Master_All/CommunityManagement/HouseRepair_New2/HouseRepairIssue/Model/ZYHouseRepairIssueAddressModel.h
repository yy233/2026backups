//
//  ZYHouseRepairIssueAddressModel.h
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYHouseRepairIssueAddressModel : NSObject <YYModel>

// 唯一标识id
@property (nonatomic, copy) NSString *ID;

// 区域名称
@property (nonatomic, copy) NSString *region;

@end

NS_ASSUME_NONNULL_END
