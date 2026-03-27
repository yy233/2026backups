//
//  SmallShppOrderViewModel.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShppOrderViewModel.h"
#import "SmallShopOrderHeader.h"

#define  data_records_Key                 @"records"

static NSString *const kOrderListData_Url = @"order/selectByUserIdPage";

@interface SmallShppOrderViewModel ()
@property (nonatomic,strong) NSMutableArray *saveOldArrChangeNewArr;

@end
@implementation SmallShppOrderViewModel
- (NSMutableArray *)saveOldArrChangeNewArr{
    if (!_saveOldArrChangeNewArr) {
        _saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveOldArrChangeNewArr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 1;
    }
    return self;
}


- (void)getDataListOnePage{
    self.pageNum = 1;
    [self getNetDataWithPageNum:1 withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
          
            if(arr.count>0){
                self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithArray: [SmallShppOrderModel mj_objectArrayWithKeyValuesArray:arr]];
                self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                //
                self.showMsgStr = @"获取成功";
                self.pageNum += 1;
            }else{
                self.showMsgStr = @"暂无数据";
            }
    
        }else{
            self.showMsgStr = @"获取失败";
        }
        //showtype
        self.thisIsSuccessBool = success;
    }];
    
}
- (void)getDataListNextPage{

    [self getNetDataWithPageNum:self.pageNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
            //
            [self.saveOldArrChangeNewArr  addObjectsFromArray: [SmallShppOrderModel mj_objectArrayWithKeyValuesArray:arr]];
            self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
            //
            if(arr.count>0){
                self.showMsgStr = @"加载成功";
                self.pageNum += 1;
            }else{
                self.showMsgStr = @"暂无更多数据";
            }
        }else{
            self.showMsgStr = @"获取失败";
        }
        //showtype
        self.thisIsSuccessBool = success;
    }];
    
}

- (void)getNetDataWithPageNum:(NSInteger)willGetPageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{//订单 按小区分
     NSDictionary *parms = @{
        @"page":@(self.pageNum),
        @"size":@(Y_PAGE_SIZE_10),
        @"storeId": [SmallShopNowShopShare share].saveNowShopId,
        @"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)
    };
    
   
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(kOrderListData_Url) withBody:parms.mutableCopy finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSDictionary *dataDic = Y_ResponsObject_dataDic;
                 NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                 block(getArrs,YES);

             }else{
                 block(@[],NO);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     Y_SVP_SHOW_ERR_MESSAGE
                 });
             }
         }else{
             block(@[],NO);
             dispatch_async(dispatch_get_main_queue(), ^{
                 Y_SVP_SHOW_ERR_DESCRIPTION
             });
         }
     }];
 
    
 
}
 
 
@end
