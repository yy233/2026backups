//
//  creatDbTool.m
//  Socialize
//
//  Created by 余莹 on 2023/7/11.
//

#import "creatDbTool.h"
#import <sqlite3.h>
#import "FMDB.h"

#define kMiYao  @"123456"

@interface creatDbTool ()

{
    FMDatabase *db;
    NSString *dbPath;
}
@end

@implementation creatDbTool
singleton_implementation(share);
- (NSString *)paths{
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbPath = [directory stringByAppendingPathComponent:@"create5.db"];
    return dbPath;
    
}
- (void)create{
    NSLog(@"createcreatecreatecreatecreatecreatecreatecreatecreatecreate");
    dbPath = [self paths];
    
    db = [FMDatabase databaseWithPath:dbPath];

    if([db open]){
        
        BOOL e =  [db setKey:kMiYao];
         NSLog(@"setKey ---  ok == %d",e );
        
        NSString *sqCreat = @"CREATE TABLE demo005 ( id  INTEGER, name  TEXT);";
        BOOL crok =   [db executeUpdate:sqCreat];
        if(crok){
            NSLog(@"crok");
            
            //
            BOOL iok =   [db executeUpdate:@"INSERT INTO demo005 (id,name) VALUES (111,'fffffffw');"];
            NSLog(@"iok == %d",iok);
            
            BOOL iokk =   [db executeUpdate:@"INSERT INTO demo005 (id,name) VALUES (222,'ffffffe');"];
            NSLog(@"iokk == %d",iokk);
            
            
            //
            
            FMResultSet *resultSet  =   [db executeQuery:@"SELECT *from demo005"];
 
             while ([resultSet next]) {
                 NSLog(@"cc----");
                 NSLog(@"c当前循环到item 全部数据index == %@",[resultSet columnNameToIndexMap]);//当前循环到item 全部数据
         
                 NSString *name = [resultSet stringForColumn:@"name"];
                 NSLog(@"c当前循环到item name = %@",name);
                 NSString *idstr = [resultSet stringForColumn:@"id"];
                 NSLog(@"c当前循环到item idstr = %@",idstr);
                 NSLog(@"ccc----");
               
             }
             
            
            
        }else{
            NSLog(@"未 crok");
        }
        [db close];
    }else{
        NSLog(@"未开");
    }
    
}

 

- (void)search1{
//    dbPath = [self paths];
//    db = [FMDatabase databaseWithPath:dbPath];
//    if([db open]){
//         
//       FMResultSet *resultSet  =   [db executeQuery:@"SELECT *from demo005"];
//        while ([resultSet next]) {
//            NSLog(@"----");
//            NSLog(@"当前循环到item 全部数据index == %@",[resultSet columnNameToIndexMap]);//当前循环到item 全部数据
//    
//            NSString *name = [resultSet stringForColumn:@"name"];
//            NSLog(@"当前循环到item name = %@",name);
//            NSString *idstr = [resultSet stringForColumn:@"id"];
//            NSLog(@"当前循环到item idstr = %@",idstr);
//            NSLog(@"----");
//          
//        }
//        
//        [db close];
//    }
    

}

- (void)encrydb{
    
    if([db open]){
        
       BOOL e =  [db setKey:kMiYao];
        NSLog(@"e ok == %d",e );
        
    }
    
}

//- (void)unencrydb{
//
//    if([db open]){
//
//       BOOL re =  [db rekey:nil];
//        NSLog(@"re ok == %d",re );
//
//    }
//}



- (void)search2{
  
    if([db open]){
         
        
       BOOL re =  [db setKey:kMiYao];
        NSLog(@"222re ok == %d",re );
        
        
        
       FMResultSet *resultSet  =   [db executeQuery:@"SELECT *from demo005"];

        while ([resultSet next]) {
            NSLog(@"----");
            NSLog(@"当前循环到item 全部数据index == %@",[resultSet columnNameToIndexMap]);//当前循环到item 全部数据
    
            NSString *name = [resultSet stringForColumn:@"name"];
            NSLog(@"当前循环到item name = %@",name);
            NSString *idstr = [resultSet stringForColumn:@"id"];
            NSLog(@"当前循环到item idstr = %@",idstr);
            NSLog(@"----");
          
        }
        
        [db close];
    }else{
        NSLog(@"----no open");
    }
    

}

@end
