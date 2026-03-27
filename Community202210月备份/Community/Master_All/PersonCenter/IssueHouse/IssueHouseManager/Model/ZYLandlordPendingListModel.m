//
//  ZYLandlordPendingListModel.m
//  Community
//
//  Created by ZY on 2021/9/10.
//

#import "ZYLandlordPendingListModel.h"

@implementation ZYLandlordPendingListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYLandlordPendingListDataModel class]};
}

@end


@implementation ZYLandlordPendingListDataModel

@end
