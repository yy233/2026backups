//
//  MainWeatherModel.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "MainWeatherModel.h"

@implementation MainWeatherModel 
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (oldValue == [NSNull null]) {
        
        if ([oldValue isKindOfClass:[NSArray class]]) {
            
            return @[];
            
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            
            return @{};
            
        }else if([oldValue isKindOfClass:[NSString class]]){
            
            return @"";
            
        }else{
            return 0;
        }
        
    }
    return oldValue;
}
@end
