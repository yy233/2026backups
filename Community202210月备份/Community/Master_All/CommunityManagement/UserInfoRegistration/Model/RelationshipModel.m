//
//  RelationshipModel.m
//  Community
//  亲属关系
//  Created by 余莹 on 2020/12/9.
//

#import "RelationshipModel.h"

@implementation RelationshipModel
//与业主关系 1.夫妻 2.父子 3.母子 4.父女 5.母女 6.亲属
+ (NSString *)getRelationShipRelativeNameWithCode:(NSInteger)code{//和业主的亲属关系

    switch (code) {
        case 1:
            return @"夫妻";
            break;
        case 2:
            return @"父子";
            break;
        case 3:
            return @"母子";
            break;
        case 4:
            return @"父女";
            break;
        case 5:
            return @"母女";
            break;
        case 6:
            return @"亲属";
            break;
            
        default:
            return @"亲属";
            break;
    }
}

@end
