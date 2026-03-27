//
//  ZYLocationInfoTool.m
//  ZYVC
//
//  Created by ZY on 2021/5/23.
//

#import "ZYLocationInfoTool.h"

@implementation ZYLocationInfoTool

+ (void)getLocatonInfoWithLat:(CLLocationDegrees)lat AndLon:(CLLocationDegrees)lon LocatonInfoBlock:(nonnull ZYLocatonInfoBlock)block {
    ZYLocatonInfoBlock infoBlock = block;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSString *subLocality = placemark.subLocality;
            NSString *thoroughfare = placemark.thoroughfare;
            NSString *subThoroughfare = placemark.subThoroughfare;
            NSMutableString *mStr = [NSMutableString string];
            if (city.length > 0) {
                [mStr appendString:city];
            }
            if (subLocality.length > 0) {
                [mStr appendString:subLocality];
            }
            if (thoroughfare.length > 0) {
                [mStr appendString:thoroughfare];
            }
            if (subThoroughfare.length > 0) {
                [mStr appendString:subThoroughfare];
            }
            infoBlock([mStr copy]);
            NSLog(@"%@", [mStr copy]);
        }else if (error == nil && [array count] == 0) {
            infoBlock(@"没有获取到定位坐标!");
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            infoBlock(@"没有获取到定位坐标!");
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

@end
