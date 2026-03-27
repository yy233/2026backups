//
//  CigarBrands.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/16.
// 品牌

#import "CigarBrandsUseModel.h"


#pragma mark ============================================= base
#pragma mark ==
@implementation BaseSVModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{ //  NSObject+MJKeyValue.h return @{@"ID":@"id"};
    return  @{@"s":@"String",
              @"v":@"Valid"};
}
@end

#pragma mark ==
@implementation Pic
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"s":@"String",
              @"v":@"Valid"};
}
@end

#pragma mark ==
@implementation Icon
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"s":@"String",
              @"v":@"Valid"};
}
@end

#pragma mark ==
@implementation EngName
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"s":@"String",
              @"v":@"Valid"};
}
@end

#pragma mark ==
@implementation TimeDateInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{ //  NSObject+MJKeyValue.h return @{@"ID":@"id"};
    return  @{@"T":@"Time",
              @"v":@"Valid"};
}
@end
 

#pragma mark ============================================= 品牌
#pragma mark ==
@implementation CigarBrandsUseModel

@end

#pragma mark ==
@implementation BrandTypesModel : NSObject

@end

#pragma mark ==
@implementation BrandStockInFoModel : NSObject

@end
 

 

#pragma mark ============================================= 位置
#pragma mark ==
@implementation PlaceModel : NSObject

@end

#pragma mark ==
@implementation CabinetModel : NSObject

@end


#pragma mark ==
@implementation LevelModel : NSObject

@end

#pragma mark ============================================= 品牌
@implementation InsertBrandModel : NSObject
 
@end

#pragma mark ==
@implementation InsertBrandTypeModel : NSObject
 
@end

 

#pragma mark ============================================= 位置



#pragma mark =============================================入库创建存/出库下订单相关
#pragma mark ==
@implementation CreateOrdersModel : NSObject

@end

#pragma mark ==
@implementation InsertStockModel : NSObject

@end
 
