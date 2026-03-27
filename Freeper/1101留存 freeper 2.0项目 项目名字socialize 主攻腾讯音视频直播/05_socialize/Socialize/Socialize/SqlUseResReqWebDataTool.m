//
//  SqlUseResReqWebDataTool.m
//  Socialize
//
//  Created by 余莹 on 2023/8/7.
//

#import "SqlUseResReqWebDataTool.h"
#import "WalletSqlTools.h"

@interface SqlUseResReqWebDataTool ()
{
//    dispatch_queue_t sqlUse_Updata_conCurrentQueue;//并行 同步
    dispatch_queue_t sqlUse_serialQueue;//串行队列+异步任务：开启新的线程，任务逐步完成
}
@end

@implementation SqlUseResReqWebDataTool
singleton_implementation(share)

#pragma mark === sql

 
- (void)initSqlUseQu{
//    sqlUse_Updata_conCurrentQueue = dispatch_queue_create("sqlUseUpData.conCurrentQueue",DISPATCH_QUEUE_CONCURRENT);
    sqlUse_serialQueue = dispatch_queue_create("sqlUse.serialQueue", DISPATCH_QUEUE_SERIAL);
}

#pragma mark === sql
- (void)haveSqlInfoWithType:(NSInteger)type
              withSqlStrArr:(NSArray *)sqlArr
         withMessageBodyDic:(NSDictionary *)messageBodyDic
    ofwillUseSendWkDicBlock:(BaseDicAndSuccessBoolBlock)block{

    DLog(@"haveSqlInfoWithType  toolGetKeyWindow].rootViewController ---- %@",[Y_ToolOfOthers toolGetKeyWindow].rootViewController);

    if(isNil(sqlUse_serialQueue)){
        [self initSqlUseQu];
    }
     
    switch (type) {    //0 delet 1 insert  2update 3查询select
            //
        case 0:   case 1:   case 2:
        {
            dispatch_async(sqlUse_serialQueue, ^{
                NSLog(@"type %ld withSqlStrArr === %@",(long)type,sqlArr)
                WEAKSELF
                [[WalletSqlTools share] updataThingsWithSqlArr:sqlArr withBlock:^(BOOL successs, NSMutableArray * _Nonnull resArr) {
                    if(successs){
                        NSLog(@"成功的更新");
                    }else{
                        NSLog(@"失败的更新");
                    }
                    [weakSelf appiCallDealSqlInfoWithType:type WithResArr:resArr WithOldMessagebody:messageBodyDic ofwillUseSendWkDicBlock:block];
                }];
                
            });
      
            
            //并行队列同步：操作不会新建线程、操作顺序执行； 创建时用这个（并行+同步它是串行之心的哦）
            //并行队列异步操作会新建多个线程（有多少任务，就开n个线程执行）、操作无序执行；队列前如果有其他任务，会等待前面的任务完成之后再执行；场景：既不影响主线程，又不需要顺序执行的操作！
        }
            break;
        case 3:
        {
            // 串行队列+同步任务：不会开启新的线程，任务逐步完成（不要向同一个串行队列添加同步任务，进行中的任务等待添加任务完成，添加的任务等待上一个任务完成，因为相互等待死循环）。
            // 串行队列异步：操作需要一个子线程，会新建线程、线程的创建和回收不需要程序员参与，操作顺序执行，是最安全的选择；）
            
            dispatch_async(sqlUse_serialQueue, ^{
                NSLog(@"type %ld withSqlStrArr === %@",(long)type,sqlArr)
                WEAKSELF
                [[WalletSqlTools share] selectThingsWithSqlArr:sqlArr withBlock:^(BOOL successs, NSMutableArray * _Nonnull resArr) {
                    if(successs){
                        NSLog(@"sql成功的查询");
                    }else{
                        NSLog(@"sql失败的查询");
                    }
                    [weakSelf appiCallDealSqlInfoWithType:type WithResArr:resArr WithOldMessagebody:messageBodyDic ofwillUseSendWkDicBlock:block];
                }];
               });
        }
            break;
            
        default:
        {
            block(@{},NO);
        }
            break;
    }
    
    /**
     
     a.串行队列+同步任务：不会开启新的线程，任务逐步完成。
     b.并行队列+同步任务：不会开启新的线程，任务逐步完成。
     c.串行队列+异步任务：开启新的线程，任务逐步完成。 。。。。是最安全的选择
     d.并行队列+异步任务：开启新的线程，任务是同步执行的。
     */
    /*
    dispatch_queue_t：队列
    DISPATCH_QUEUE_SERIAL：串行
    DISPATCH_QUEUE_CONCURRENT：并行
    */
    
}

- (void)appiCallDealSqlInfoWithType:(NSInteger)type WithResArr:(NSMutableArray *)resArr WithOldMessagebody:(NSDictionary *)messageBodyDic ofwillUseSendWkDicBlock:(BaseDicAndSuccessBoolBlock)block{
    
    //处理info
    WebViewUseDataModel_sqlUse *mainDataModel = [WebViewUseDataModel_sqlUse mj_objectWithKeyValues:messageBodyDic];
    NSMutableDictionary *willUseSendWkDic = @{}.mutableCopy;
    
    [willUseSendWkDic setValue:@"res" forKey:@"type"];//固定值
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.ID] forKey:@"id"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.refer] forKey:@"to"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.data.method] forKey:@"method"];

    //0 delet 1 insert  2update 3查询select
    if(type == 3){//查询
        [willUseSendWkDic setValue:resArr forKey:@"result"];
    }else {//更新
        NSInteger numI = 0;
        for (NSNumber *resArrSubNum in resArr) {
            if([resArrSubNum isEqualToNumber: @(1)]){
                numI += 1;
            }
        }
        [willUseSendWkDic setValue:@(numI) forKey:@"result"];
    }

    block(willUseSendWkDic,YES);
 
}

@end
