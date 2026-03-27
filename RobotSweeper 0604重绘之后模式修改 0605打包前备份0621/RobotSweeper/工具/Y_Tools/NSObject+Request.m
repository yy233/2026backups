//
//  NSObject+Request.m
//  北碚区博物馆巡查系统
//
//  Created by yy on 16/12/12.
//  Copyright © 2016年 yaltec. All rights reserved.
//

#import "NSObject+Request.h"
#import "AFNetworking.h"
#import "Reachability.h"


@implementation NSObject (Request)
- (AFHttpNetworkStatus)currentNetworkStatus{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus value = [reachability currentReachabilityStatus];
    switch (value) {
        case NotReachable:
            return AFHttpNotReachable;
            break;
        case ReachableViaWiFi:
            return AFHttpReachableViaWiFi;
            break;
        case ReachableViaWWAN:
            return AFHttpReachableViaWWAN;
            break;
           
        default:
            return AFHttpNotReachable;
            break;
    }
    
}




@end
