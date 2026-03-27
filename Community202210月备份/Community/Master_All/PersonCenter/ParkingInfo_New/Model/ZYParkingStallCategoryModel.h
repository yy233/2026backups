//
//  ZYParkingStallCategoryModel.h
//  Community
//
//  Created by ZY on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingStallCategoryModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 车场分类名称
@property (nonatomic, copy) NSString *siteClassificationName;

@end

NS_ASSUME_NONNULL_END
