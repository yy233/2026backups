//
//  ZhiBoMyListViewModel.m
//  Socialize
//
//  Created by 余莹 on 2023/7/3.
//

#import "ZhiBoMyListViewModel.h"
static NSString *const kMyZhiBoListData_sub_Url = @"/activity/auth/getUserActivityList";//isMyZhiBoType

@implementation ZhiBoMyListViewModel


- (void)getDataListOnePage{
    self.pageNum = 1;
    [self getNetDataWithPageNum:1 withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
            
            if(arr.count>0){//只做数据处理 0时page不做处理
                
                NSMutableArray *modelArr = @[].mutableCopy;
//                for ( int i = (int)arr.count ; i > 0; i++) {//从大i到0
//                    [modelArr addObject: [ZhiBoShowInfoModel mj_objectWithKeyValues:arr[i-1]]];
//                }
                for ( int i = 0 ; i < arr.count; i++) {//从大i到0
                    [modelArr addObject: [ZhiBoShowInfoModel mj_objectWithKeyValues:arr[i]]];
                }
                self.dataOfArr = [[NSMutableArray alloc]initWithArray: modelArr];
                self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithArray: modelArr];
                //第一页pageNum = 1;
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"获取成功");
                self.pageNum += 1;
            }else{
                self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithCapacity:0];
                self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"暂无数据");
                
            }
            
        }else{
            self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"获取失败");
        }
        //showtype
        self.thisIsSuccessBool = success;
    }];
    
}
- (void)getDataListNextPage{
    
    [self getNetDataWithPageNum:self.pageNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
            
            NSLog(@"self.saveOldArrChangeNewArr c = %lu",(unsigned long)self.saveOldArrChangeNewArr.count);
            for ( int i = 0 ; i < arr.count; i++) {//从大i到0
                [self.saveOldArrChangeNewArr addObject: [ZhiBoShowInfoModel mj_objectWithKeyValues:arr[i]]];
            }
            NSLog(@"self.saveOldArrChangeNewArr c = %lu",(unsigned long)self.saveOldArrChangeNewArr.count);
            
            self.dataOfArr = [[NSMutableArray alloc]initWithArray: self.saveOldArrChangeNewArr];
            NSLog(@"self.dataOfArr c = %lu",(unsigned long)self.dataOfArr.count);
            //第一页pageNum = 1;
       
            if(arr.count>0){
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"加载成功");
                self.pageNum += 1;
                NSLog(@"新的一页 有数据 pageNum增加 用于下次数据直接使用");
            }else{
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"暂无更多数据");
                NSLog(@"新的一页 没有数据 pageNum不增加 self.pageNum %ld",self.pageNum);
            }
        }else{
            self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"获取失败");
        }
        //showtype
        self.thisIsSuccessBool = success;
    }];
    
}

- (void)getNetDataWithPageNum:(NSInteger)willGetPageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{

    [self.thisParms setValue:@(Y_PAGE_SIZE_10)   forKey:@"count"];
    [self.thisParms setValue:@(willGetPageNum)   forKey:@"page"];
    NSMutableDictionary *parms = self.thisParms;
    NSString * kZhiBoListData_AllUrl = Y_AllURL_Main(kMyZhiBoListData_sub_Url);
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLPostNotMainQueue:kZhiBoListData_AllUrl withParams:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                NSLog(@"列表 getArrs = %@",getArrs);
                block(getArrs,YES);
                
            }else{
                block(@[],NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@[],NO);
            if((error.code == -1011) && [error.userInfo.allValues containsObject:@"Request failed: bad request (400)"]){
                NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_DESCRIPTION
                });
            }
        }
    }];
    
    
    
}

@end
