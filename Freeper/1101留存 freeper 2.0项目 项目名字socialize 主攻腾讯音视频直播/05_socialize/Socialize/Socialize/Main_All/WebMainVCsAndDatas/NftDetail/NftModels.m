//
//  NftModels.m
//  Socialize
//
//  Created by 余莹 on 2023/8/29.
//

#import "NftModels.h"

@implementation NftModelsSubUser


@end

@implementation NftModels

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"user" : [NftModelsSubUser class],
             
    };
}
@end
