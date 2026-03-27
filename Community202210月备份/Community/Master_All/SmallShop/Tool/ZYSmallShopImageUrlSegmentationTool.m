//
//  ZYSmallShopImageUrlSegmentationTool.m
//  Community
//
//  Created by ZY on 2022/3/3.
//

#import "ZYSmallShopImageUrlSegmentationTool.h"

@implementation ZYSmallShopImageUrlSegmentationTool

+ (ZYImageWidthHeightModel *)imageUrlSegmentationWithUrlStr:(NSString *)urlStr {
    ZYImageWidthHeightModel *model = [[ZYImageWidthHeightModel alloc] init];
    NSArray *array = [urlStr componentsSeparatedByString:@"_"];
    if (array.count > 3) {
        model.width = [array[array.count - 3] doubleValue];
        model.height = [array[array.count - 2] doubleValue];
    }
    
    return model;
}

@end
