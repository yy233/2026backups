//
//  PositioningManager.m
//  Community
// 首页无小区无house时获取当前地址最近的小区
//  Created by 余莹 on 2020/11/26.
//

#import "NativePositioningManager.h"

@implementation NativePositioningManager
 
+ (NativePositioningManager *)sharedGpsManager {
    static NativePositioningManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[NativePositioningManager alloc] init];
    });
    return shared;
}

- (id)init{
    self = [super init];
    if (self) {
        //如果设备没有开启定位服务
        if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            
//        }
//        if (![manager locationServicesEnabled]){
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(@"定位权限未开启");
                return;
            });
        }
        // 打开定位 然后得到数据
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        //控制定位精度,越高耗电量越
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 兼容iOS8.0版本
       
        // 请求授权 requestWhenInUseAuthorization用在>=iOS8.0上
        // respondsToSelector: 前面manager是否有后面requestWhenInUseAuthorization方法
        // 1. 适配 动态适配
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
        // 2. 另外一种适配 systemVersion 有可能是 8.1.1
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 8) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void)getMoLocationWithSuccess:(LocationSuccessNativeGet)success Failure:(LocationFailedNativeGet)failure {
    successCallBack = [success copy];
    failedCallBack = [failure copy];
    // 停止上一次的
    [manager stopUpdatingLocation];
    // 开始新的数据定位
    [manager startUpdatingLocation];
}


+ (void)getMoLocationWithSuccess:(LocationSuccessNativeGet)success Failure:(LocationFailedNativeGet)failure {
    [[NativePositioningManager sharedGpsManager] getMoLocationWithSuccess:success Failure:failure];
}


- (void)stop {
    [manager stopUpdatingLocation];
}

+ (void)stop {
    [[NativePositioningManager sharedGpsManager] stop];
}

// 每隔一段时间就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    for (CLLocation *loc in locations) {
        CLLocationCoordinate2D l = loc.coordinate;
        double lat = l.latitude;
        double lnt = l.longitude;
        successCallBack ? successCallBack(lat, lnt) : nil;
        
    }
}

//失败代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSError *eNil = [[NSError alloc]init];
    failedCallBack ? failedCallBack(error) : failedCallBack(eNil) ;//Called function pointer is null (null dereference)
    if ([error code] == kCLErrorDenied) {
        NSLog(@"locationManager访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"locationManager无法获取位置信息");
    }
}

/**
 //只获取一次
  __block  BOOL isOnece = YES;
  [MoLocationManager getMoLocationWithSuccess:^(double lat, double lng){
      isOnece = NO;
      //只打印一次经纬度
      NSLog(@"lat lng (%f, %f)", lat, lng);
      
      if (!isOnece) {
          [MoLocationManager stop];
      }
  } Failure:^(NSError *error){
      isOnece = NO;
      NSLog(@"error = %@", error);
      if (!isOnece) {
          [MoLocationManager stop];
      }
  }];
  
 //    //一直持续获取定位则
 //    [MoLocationManager getMoLocationWithSuccess:^(double lat, double lng){
 //        //不断的打印经纬度
 //        NSLog(@"lat lng (%f, %f)", lat, lng);
 //    } Failure:^(NSError *error){
 //        NSLog(@"error = %@", error);
 //    }];
 */

@end
