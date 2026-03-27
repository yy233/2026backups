//
//  HttpResult.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "HttpResult.h"

@implementation HttpResult

-(BOOL)isSuccess{
//    if (self.status == 1) {
//        return YES;
//    }
//    return NO;
  return YES;
}

-(id)data{
    if (_data) {
        if ([_data isKindOfClass:[NSDictionary class]] && !_data[@"data"]) {
            NSMutableDictionary *ENO_mut = [_data mutableCopy];
            ENO_mut[@"data"] = @[];
        }
    }
    return _data;
}

-(id)datas{
    if (_datas) {
        if ([_datas isKindOfClass:[NSDictionary class]] && !_datas[@"_datas"]) {
            NSMutableDictionary *ENO_mut = [_data mutableCopy];
            ENO_mut[@"_datas"] = @[];
        }
    }
    return _datas;
}

@end
