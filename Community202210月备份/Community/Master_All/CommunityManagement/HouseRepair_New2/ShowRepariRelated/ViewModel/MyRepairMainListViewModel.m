//
//  HouseRepairMainListViewModel.m
//  Community
//
//  Created by 余莹 on 2022/3/4.
//报事报修

#import "MyRepairMainListViewModel.h"

static NSString *const Url_SelectHouseRepairList   =    @"proprietor/repair/listRepairOrder";//列表接口
#define ReqData_SubListKeyStr  @"records"

@interface MyRepairMainListViewModel ()
@end


@implementation MyRepairMainListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

 
//999全部
- (void)getDataListOnePageWithType:(MyRepair_PageList_Show_Type)dataType{
    self.saveNowListTypeWithDealData = dataType;
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    parms = @{
        @"page":@(1),
        @"size":@(Y_PAGE_SIZE_10),
    }.mutableCopy;
    
    /**
     //状态 0413改动
     //旧
     //[parms setValue:@{@"status":@(self.saveNowDataType)}   forKey:@"query"];
     //新
     （0 待处理 1 处理中 2 已完成  已驳回3）--- 展示类型
     【工单状态:0 待处理 1已接单 2处理中 4已完结】--- 请求数据
     **/
    
    NSLog(@"当前类型 = %lu" ,(unsigned long)self.saveNowListTypeWithDealData );

    NSMutableDictionary *queryDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [queryDic  setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];    //社区
    if ( self.saveNowListTypeWithDealData == MyRepair_PageList_Show_Type_All ) {
        [queryDic setValue:@[@0,@1,@2,@4]   forKey:@"statusList"];
        NSLog(@"当前类型 = all"  );
    }else if ( self.saveNowListTypeWithDealData == MyRepair_PageList_Show_Type_Will ){//待处理
        [queryDic setValue:@[@0]  forKey:@"statusList"];
        NSLog(@"当前类型 = 待处理"  );
    }else if ( self.saveNowListTypeWithDealData == MyRepair_PageList_Show_Type_Ing ){//处理中
        [queryDic setValue:@[@1,@2]  forKey:@"statusList"];
        NSLog(@"当前类型 = 处理中"  );
    }else if ( self.saveNowListTypeWithDealData == MyRepair_PageList_Show_Type_End ){//完成
        [queryDic setValue:@[@4]  forKey:@"statusList"];
        NSLog(@"当前类型 = 完成"  );
    }else{//其他类型
    }
    [parms setValue:queryDic forKey:@"query"];
    NSLog(@"列表parms = %@ ",parms);
  
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:Url_SelectHouseRepairList withParams:parms finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //
                NSMutableDictionary *getDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArr =    ( [[getDic allKeys] containsObject:ReqData_SubListKeyStr]  \
                                             && isNotNil([getDic objectForKey:ReqData_SubListKeyStr]) ) \
                                             ? [getDic objectForKey:ReqData_SubListKeyStr] : [NSMutableArray array];
                //
                if (getArr.count>0) {
                    weakSelf.pageNum += 1;
                    //weakSelf.showMsgStr =  Y_ResponsObject_messageStr;
                    weakSelf.showMsgStr = @"加载成功";
                    
                }else{
                    weakSelf.showMsgStr = @"暂无数据";
                }
                //s
                weakSelf.dataOfArr = [NSArray arrayWithArray: [MyRepairPageListUseModel mj_objectArrayWithKeyValuesArray:getArr]];
                weakSelf.thisIsSuccessBool = YES;
           
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Y_SVP_SHOW_ERR_MESSAGE
                    weakSelf.thisIsSuccessBool = NO;
                    weakSelf.showMsgStr = Y_ResponsObject_messageStr;
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
    
}
- (void)getDataListNextPage{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    parms = @{
        @"page":@(self.pageNum),
        @"size":@(Y_PAGE_SIZE_10),
    }.mutableCopy;
    
    if ( self.saveNowListTypeWithDealData == HouseRepair_PageList_Type_All ) {
    }else{
        [parms setValue:@{@"status":@(self.saveNowListTypeWithDealData)}   forKey:@"query"];
    }

    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:Url_SelectHouseRepairList withParams:parms finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //
                NSMutableDictionary *getDic = Y_ResponsObject_dataDic;

                NSMutableArray *getArr =    ( [[getDic allKeys] containsObject:ReqData_SubListKeyStr]  \
                                             && isNotNil([getDic objectForKey:ReqData_SubListKeyStr]) ) \
                                             ? [getDic objectForKey:ReqData_SubListKeyStr] : [NSMutableArray array];
                //
                if (getArr.count>0) {
                    weakSelf.pageNum += 1;
                }
                //
                NSMutableArray *changeUseArr = [NSMutableArray arrayWithArray:weakSelf.dataOfArr];
                [changeUseArr addObjectsFromArray:[MyRepairPageListUseModel mj_objectArrayWithKeyValuesArray:getArr] ];
                //
                weakSelf.dataOfArr = [NSArray arrayWithArray:changeUseArr];
                weakSelf.thisIsSuccessBool = YES;
                weakSelf.showMsgStr =  @"加载成功";// Y_ResponsObject_messageStr;
               
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Y_SVP_SHOW_ERR_MESSAGE
                    weakSelf.thisIsSuccessBool = NO;
                    weakSelf.showMsgStr = Y_ResponsObject_messageStr;
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
    
}


@end
