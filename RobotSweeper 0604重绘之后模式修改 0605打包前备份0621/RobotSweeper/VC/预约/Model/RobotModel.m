//
//  RobotModel.m
//  扫地机闹钟多表联查
//
//  Created by Joey on 2018/4/12.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "RobotModel.h"

@implementation RobotModel
+ (LKDBHelper *)getUsingLKDBHelper {
    
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //DB 路径
        NSString* DBPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/DB/RobotListDB.db"];
        NSLog(@"DB 路径%@", DBPath);
        db = [[LKDBHelper alloc] initWithDBPath:DBPath];
    });
    return db;
}

//在类 初始化的时候
+ (void)initialize {
    
    //如果getTableMapping 返回 nil, 会取全部属性， 如果有不想要的属性，可以使用
    //    [self removePropertyWithColumnName:@"age"];
    //    [self removePropertyWithColumnNameArray:@[@"age", @"name"]];
    
    //修改列名
    //    [self setTableColumnName:@"MyAge" bindingPropertyName:@"age"];
    
    //手动设置关联外键变量名
    //    [self setUserCalculateForCN:@""];
    
    /*
     这个方法是用来绑定当前表需要哪些列属性的， 如果返回 nil , 则默认绑定 Model 所有的属性名，作为 列名。  如果有个别不想绑定进数据库的，可以在 initialize 方法中，使用 [self removePropertyWithColumnName:@"列名"] ;
     来进行移除，也可以手动修改个别你需要更改列名的列：
     
     [self setTableColumnName:@"新列名" bindingPropertyName:@"原列名"];
     
     如果你有两张或者以上的表互相关联，需要设置外键的话，可以在 initialize 方法中调这个方法：
     
     [self setUserCalculateForCN:@"关联的表，在当前属性中创建的变量名"];
     
     这个参数什么意思？ 比如： 有个A 类 和 B类 关联。
     
     那么在 B 类的属性中，就会创建一个这样的属性
     
     @property (nonatomic, strong) A *thisAObj;
     
     则在 B 的这个方法里就要这么写:
     
     [self setUserCalculateForCN:@"thisAObj"];
     */
}
+ (void)dbDidAlterTable:(LKDBHelper *)helper tableName:(NSString *)tableName addColumns:(NSArray *)columns {
    
    LKErrorLog(@"your know %@",columns);
}

// 将要插入数据库
+ (BOOL)dbWillInsert:(NSObject *)entity {
    LKErrorLog(@"将要插入 : %@",NSStringFromClass(self));
    return YES;
}

//已经插入数据库
+ (void)dbDidInserted:(NSObject *)entity result:(BOOL)result {
    LKErrorLog(@"已经插入 : %@",NSStringFromClass(self));
}

+ (BOOL)dbWillUpdate:(NSObject*)entity {
    LKErrorLog(@"将要更新 : %@",NSStringFromClass(self));
    return YES;
}

+ (void)dbDidUpdated:(NSObject*)entity result:(BOOL)result {
    LKErrorLog(@"已经更新 : %@",NSStringFromClass(self));
}

+ (BOOL)dbWillDelete:(NSObject*)entity {
    LKErrorLog(@"将要删除 : %@",NSStringFromClass(self));
    return YES;
}

+ (void)dbDidDeleted:(NSObject*)entity result:(BOOL)result {
    LKErrorLog(@"已经删除 : %@",NSStringFromClass(self));
}

//手动or自动 绑定sql列
+ (NSDictionary *)getTableMapping {
    //返回nil 就是自动绑定所有列名
    return nil;
    
    //    return @{@"age":@"Myage"};
}

//主键
+ (NSString *)getPrimaryKey {
    return @"ID";
}

///复合主键  这个优先级最高
//+(NSArray *)getPrimaryKeyUnionArray {
//    return @[@"name",@"age"];
//}

//表名
+ (NSString *)getTableName {
    return NSStringFromClass(self);
}

//是否将父实体类的属性也映射到sqlite库表
+ (BOOL)isContainParent {
    return YES;
}
@end
