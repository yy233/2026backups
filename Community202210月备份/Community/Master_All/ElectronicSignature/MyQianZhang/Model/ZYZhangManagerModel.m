//
//  ZYZhangManagerModel.m
//  Community
//
//  Created by ZY on 2021/5/11.
//

#import "ZYZhangManagerModel.h"

@implementation ZYZhangManagerModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYZhangManagerDataModel class]};
}

@end


@implementation ZYZhangManagerDataModel

@end

