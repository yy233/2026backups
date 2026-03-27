//
//  TableViewTopCellModel.m
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import "TableViewTopAndCenterBannerCellModel.h"

@implementation TableViewTopAndCenterBannerCellModel
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
