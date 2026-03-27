//
//  LifeCostSaveCityInfoModel.h
//  Community
//
//  Created by 余莹 on 2022/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostSaveCityInfoModel : NSObject
singleton_interface(share);
@property (nonatomic,copy) NSString *cityName;
@end

NS_ASSUME_NONNULL_END
