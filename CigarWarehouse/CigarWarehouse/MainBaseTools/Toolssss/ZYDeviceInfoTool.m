//
//  ZYDeviceInfoTool.m
//  ZYVC
//
//  Created by ZY on 2021/5/23.
//

#import "ZYDeviceInfoTool.h"

@implementation ZYDeviceInfoTool

+ (NSString *)getDeviceInfo {
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceStr = [NSString stringWithFormat:@"%@, %@, %@ %@, %@", device.name, device.model, device.systemName, device.systemVersion, [ZYKeychainTool getDeviceIDInKeychain]];
    
    return deviceStr;
}

@end
