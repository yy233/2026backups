//
//  PositioningManager.h
//  Community
//
//  Created by 余莹 on 2020/11/26.
// 0615弃

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^LocationSuccessNativeGet) (double lat, double lng);
typedef void(^LocationFailedNativeGet) (NSError *error);

@interface NativePositioningManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *manager;
    LocationSuccessNativeGet successCallBack;
    LocationFailedNativeGet failedCallBack;
}

+ (NativePositioningManager *)sharedGpsManager;

+ (void)getMoLocationWithSuccess:(LocationSuccessNativeGet)success Failure:(LocationFailedNativeGet)failure;

+ (void)stop;

@end

NS_ASSUME_NONNULL_END
