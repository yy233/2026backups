//
//  ThemeData.m
//  RobotSweeper
//
//  Created by Joey on 2018/8/27.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ThemeData.h"

@implementation ThemeData

static  ThemeData*_instance;
#pragma -----------------------
//第2步: 分配内存空间时都会调用这个方法. 保证分配内存alloc时都相同.
+(id)allocWithZone:(struct _NSZone *)zone  {
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//第3步: 保证init初始化时都相同
+(instancetype)sharedUserTool  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ThemeData alloc] init];
    });
    return _instance;
}

//第4步: 保证copy时都相同
-(id)copyWithZone:(NSZone *)zone{
    
    
    return _instance;
}

//mrc 要加的
#if (!__has_feature(objc_arc))
//可以看出实现部分与ARC一致，下面是MRC中需要覆盖的方法
#pragma mark - MRC中需要覆盖的方法
//不需要计数器+1
- (id)retain {
    
    return self;
}

//不需要. 堆区的对象才需要
- (id)autorelease {
    return self;
}
//不需要
- (oneway void)release {
}

//不需要计数器个数. 直接返回最大无符号整数
- (NSUInteger)retainCount {
    return UINT_MAX;  //参照常量区字符串的retainCount
}

#endif
#pragma -----------------------
 

@end
