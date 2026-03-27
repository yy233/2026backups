//
//  NSObject+Request.h
//  北碚区博物馆巡查系统
//
//  Created by yy on 16/12/12.
//  Copyright © 2016年 yaltec. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef enum : NSInteger{
//    AFHttpNotReachable = 0,
//    AFHttpReachableViaWiFi,
//    AFHttpReachableViaWWAN
//}AFHttpNetworkStatus;

@interface NSObject (Request)

- (AFHttpNetworkStatus)currentNetworkStatus;
@end
