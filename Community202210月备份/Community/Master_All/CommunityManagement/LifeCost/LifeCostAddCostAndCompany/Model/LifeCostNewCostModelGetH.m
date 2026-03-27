//
//  LifeCostNewCostModelGetH.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "LifeCostNewCostModelGetH.h"
#define OneItem_H 70
@implementation LifeCostNewCostModelGetH
+ (CGFloat)getNewCostCellAllHeightWithNewCostArrCount:(NSInteger)count{
    //3个一行 1行70
    CGFloat h = (count/3)*70  + ( count%3>0?OneItem_H:0) ;//
    return h;
}
@end
