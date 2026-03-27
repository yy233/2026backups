//
//  ZYPositioningManager.m
//  Community
//
//  Created by ZY on 2021/6/10.
//

#import "ZYPositioningManager.h"
#import <CoreLocation/CoreLocation.h>
#import "TQLocationConverter.h"

@interface ZYPositioningManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) ZYPositioningModel *positioningModel;

@end

@implementation ZYPositioningManager

+ (instancetype)sharedManager {
    static ZYPositioningManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ZYPositioningManager alloc] init];
    });
    return shared;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        // 设置代理
        _locationManager.delegate = self;
        // 设置定位精确度到米
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (ZYPositioningModel *)positioningModel {
    if (!_positioningModel) {
        _positioningModel = [[ZYPositioningModel alloc] init];
    }
    
    return _positioningModel;
}

+ (void)startPositioningWithLocationCompletion:(LocationCompletion)locationCompletion {
    
    ZYPositioningManager *positioningManager = [ZYPositioningManager sharedManager];
    positioningManager.locationCompletionBlock = [locationCompletion copy];
    [positioningManager.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    CLLocationCoordinate2D coordinate2D = locations.lastObject.coordinate;
//    NSLog(@"WGS-84：lat=%lf lon=%lf", coordinate2D.latitude, coordinate2D.longitude);
    if (![TQLocationConverter isLocationOutOfChina:coordinate2D]) {
        coordinate2D = [TQLocationConverter transformFromWGSToGCJ:coordinate2D];
//        NSLog(@"GCJ-02：lat=%lf lon=%lf", coordinate2D.latitude, coordinate2D.longitude);
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.positioningModel.latitude = location.coordinate.latitude;
            self.positioningModel.longitude = location.coordinate.longitude;
            self.positioningModel.country = placemark.country;
            self.positioningModel.locality = placemark.locality;
            self.positioningModel.subLocality = placemark.subLocality;
            self.positioningModel.thoroughfare = placemark.thoroughfare;
            self.positioningModel.subThoroughfare = placemark.subThoroughfare;
            self.positioningModel.name = placemark.name;
            self.positioningModel.postalCode = placemark.postalCode;
            self.positioningModel.ISOcountryCode = placemark.ISOcountryCode;
            NSMutableString *mStr = [NSMutableString string];
            if (self.positioningModel.locality.length > 0) {
                [mStr appendString:self.positioningModel.locality];
            }
            if (self.positioningModel.subLocality.length > 0) {
                [mStr appendString:self.positioningModel.subLocality];
            }
            if (self.positioningModel.thoroughfare.length > 0) {
                [mStr appendString:self.positioningModel.thoroughfare];
            }
            if (self.positioningModel.subThoroughfare.length > 0) {
                [mStr appendString:self.positioningModel.subThoroughfare];
            }
            self.positioningModel.detailAddress = [mStr copy];
            
            self.locationCompletionBlock(self.positioningModel, nil);
        }else if (error == nil && [placemarks count] == 0) {
           
            NSError *error = [[NSError alloc] init];
            self.locationCompletionBlock(nil, error);
        } else if (error != nil){
            
            self.locationCompletionBlock(nil, error);
        }
    }];
    // 关闭更新位置服务
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
    
    self.locationCompletionBlock(nil, error);
}

@end
