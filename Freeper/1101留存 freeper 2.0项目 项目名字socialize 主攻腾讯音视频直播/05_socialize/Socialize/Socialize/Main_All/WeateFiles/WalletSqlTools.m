//
//  WalletSqlTools.m
//  Socialize
//
//  Created by 余莹 on 2023/7/12.
//

#import "WalletSqlTools.h"
#import <sqlite3.h>
#import "FMDB.h"


#define WalletSql_Name  @"WalletSql.db"
#define kMiYao  @"123456"

@interface WalletSqlTools ()

{
    FMDatabase *db;
    NSString *dbPath;
}

@end

@implementation WalletSqlTools

singleton_implementation(share);

- (NSString *)paths{
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbPath = [directory stringByAppendingPathComponent:WalletSql_Name];
    return dbPath;
    
}

- (void)initDbInfo{
    NSLog(@"createcreatecreatecreatecreatecreatecreatecreatecreatecreate");
    dbPath = [self paths];
    db = [FMDatabase databaseWithPath:dbPath];

    if(db.isOpen || [db open]){
        BOOL e =  [db setKey:kMiYao];
        NSLog(@"initDbInfo FMDatabase setKey did---  ok == %d",e );
        NSLog(@"initDbInfo close");
//        [db close];
    }else{
        NSLog(@"未开");
    }
    
}
- (void)updataThingsWithSqlArr:(NSArray *)sqlArr withBlock:(SqlDbBlock)block{
    if(dbPath.length <=0 && isNil(db)){
        [self initDbInfo];
    }
    
    
    if(db.isOpen || [db open]){
        BOOL e =  [db setKey:kMiYao];
        NSLog(@"updataTableWithSqlArr setKey ---  ok == %d",e );
        NSMutableArray *resArr = @[].mutableCopy;
        //0828012类型 做成事务方式
        
        [db beginTransaction];
        BOOL isRoollBack = NO;
        @try {
            for ( int i = 0; i < sqlArr.count; i++) {
                NSString *sqlUpdatestr = sqlArr[i];
                BOOL updateok =   [db executeUpdate:sqlUpdatestr];
                if(updateok){
                    NSLog(@"updata ok --- i = %d",i);
                }else{
                    NSLog(@"未 updata ok ----i = %d",i);
                    break;//结束循环节约时间
                }
            }
        } @catch (NSException *exception) {
            isRoollBack = YES;
            [db rollback];
            //给到返回数据全0
            for ( int i = 0; i < sqlArr.count; i++) {
                [resArr addObject:@(0)];
            }
            block(YES,resArr);
            
            
        } @finally {
            if(!isRoollBack){
                [db commit];
            }
            //给到返回数据全1
            for ( int i = 0; i < sqlArr.count; i++) {
                [resArr addObject:@(1)];
            }
            block(YES,resArr);
            
        }
        
    /**
         0828前旧版
         for ( int i = 0; i < sqlArr.count; i++) {
             NSString *sqlUpdatestr = sqlArr[i];
             BOOL updateok =   [db executeUpdate:sqlUpdatestr];
             if(updateok){
                 NSLog(@"updata ok --- i = %d",i);
                 [resArr addObject:@(1)];
             }else{
                 NSLog(@"未 updata ok ----i = %d",i);
                 [resArr addObject:@(0)];
             }
         }
 //        [db close];
         NSLog(@"updataThingsWithSqlArr close");
         block(YES,resArr);
         */
   
    }else{
        NSLog(@"未开");
        block(NO,@[].mutableCopy);
    }
    
}
- (void)selectThingsWithSqlArr:(NSArray *)sqlArr withBlock:(SqlDbBlock)block{
    if(dbPath.length <=0 && isNil(db)){
        [self initDbInfo];
    }
    
    if(db.isOpen || [db open]){
        BOOL e =  [db setKey:kMiYao];
        NSLog(@"selectThingsWithSqlArr setKey ---  ok == %d",e );
        NSMutableArray *resArr = @[].mutableCopy;

        for ( int i = 0; i < sqlArr.count; i++) {
            NSString *sqlSearchstr = sqlArr[i];
            FMResultSet *resultSet  =   [db executeQuery:sqlSearchstr];
            while ([resultSet next]) {
                NSLog(@"------i= %d",i);
                NSLog(@"当前循环到item 全部数据-key-indx == %@",[resultSet columnNameToIndexMap]);//当前循环到item 全部数据
                
                NSArray *allKey = [[resultSet columnNameToIndexMap] allKeys];
                NSMutableDictionary *resOneDataDic = [NSMutableDictionary dictionaryWithCapacity:allKey.count];
                for (int j = 0 ; j < allKey.count ; j++) {
                    NSString *keyStr = [NSString stringWithString: allKey[j]];//拿到键
                    id objx = [resultSet objectForColumn:keyStr];//对象类型 的值 ，用key去取
                    NSLog(@"keyStr %@ objx %@",keyStr,objx);
                    [resOneDataDic  setObject:objx  forKey: keyStr];
                }
                NSLog(@"当前循环到item  resOneDataDic %@",resOneDataDic);//当前循环到item 全部数据
                NSLog(@"----i= %d",i);
                [resArr addObject:resOneDataDic];
                
                /**
                 NSMutableDictionary *resOneDataDic = [NSMutableDictionary dictionaryWithCapacity:allKey.count];
                 for (int i = 0 ; i < allKey.count ; i++) {
                     NSString *keyStr = [NSString stringWithString: allKey[i]];
                     NSString *indexObj = [resultSet stringForColumn: keyStr ] ;  //indexObj nil
                 }
                 NSLog(@"当前循环到item  resOneDataDic %@",resOneDataDic);//当前循环到item 全部数据
                 NSLog(@"----i= %d",i);
                 [resArr addObject:resOneDataDic];
                 */
                
            }
//            if([resultSet next] == NO){
//            }
            //[resultSet close]; //表已经被查完了，再执行[resultSet next]操作就会报这个错误，类似于数组溢出一样。  Error calling sqlite3_step (21: out of memory) rs
            NSLog(@"selectThingsWithSqlArr 数据已经循环完 查询的arr i= %d",i);
        }
//        [db close];
        NSLog(@"selectThingsWithSqlArr close");
        block(YES,resArr);
 
    }else{
        NSLog(@"未开");
        block(NO,@[].mutableCopy);
    }
    
}

- (void)dbCloseAction{
    if(isNotNil(db) && db.isOpen ){//存在且开启 才需要关闭
        [db close];
    }
}



@end
