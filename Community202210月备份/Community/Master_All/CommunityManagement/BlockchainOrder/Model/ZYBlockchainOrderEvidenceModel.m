//
//  ZYBlockchainOrderEvidenceModel.m
//  Community
//
//  Created by ZY on 2021/10/29.
//

#import "ZYBlockchainOrderEvidenceModel.h"

@implementation ZYBlockchainOrderEvidenceModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"hashStr" : @"hash"};
}

@end
