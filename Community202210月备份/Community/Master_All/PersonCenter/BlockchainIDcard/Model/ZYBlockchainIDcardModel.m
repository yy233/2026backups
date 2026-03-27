//
//  ZYBlockchainIDcardModel.m
//  Community
//
//  Created by ZY on 2021/10/28.
//

#import "ZYBlockchainIDcardModel.h"

@implementation ZYBlockchainIDcardModel

@end


@implementation ZYBlockchainIDcardDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"hashStr" : @"hash"};
}

@end

