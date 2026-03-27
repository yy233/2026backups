//
//  MoreMenuSectionHeaderModle.m
//  Community
//
//  Created by 余莹 on 2020/12/24.
//

#import "MoreMenuSectionHeaderModle.h"

@implementation MoreMenuSectionHeaderModle
+ (NSDictionary *)objectClassInArray{
    return @{
             @"childMenus" : @"MainCenterCollectionViewCellModel",
             };

}
+ (NSDictionary *)mj_objectClassInArray{
    return @{  @"childMenus" : @"MainCenterCollectionViewCellModel", };
}
@end
