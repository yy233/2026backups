//
//  IssueHouseAppointmentManagerVcModel.m
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import "IssueHouseAppointmentManagerVcModel.h"

@implementation IssueHouseAppointmentManagerVcModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == [NSNull null]) {
        
        if ([oldValue isKindOfClass:[NSArray class]]) {
            
            return @[];
            
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            
            return @{};
            
        }else{
            
            return @"";
            
        }
        
    }
    
    return oldValue;
    
}
@end
