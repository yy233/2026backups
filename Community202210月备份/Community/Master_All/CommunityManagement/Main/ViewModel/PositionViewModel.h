//
//  PositionViewModel.h
//  Community
//
//  Created by 余莹 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MainGetCommunityInfoBlock)(CommunityModel *);
typedef void(^GetLocationBlock)(CLLocation *);
@interface PositionViewModel : NSObject
+ (void)getCommunityInfoWithBlock:(MainGetCommunityInfoBlock)block;
+ (void)getNewCommunityInfoWithLon:(double)lng AndLat:(double)lat WithModelBlock:(MainGetCommunityInfoBlock)block;
@end

NS_ASSUME_NONNULL_END
