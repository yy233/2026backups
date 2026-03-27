//
//  SmallShopCartListViewModel.m
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import "SmallShopCartListViewModel.h"
#import "SmallShopCartListModel.h"

#define  Cart_Url                         @"zhsj/cabinet/"
#define  data_records_Key                 @"records"

static NSString *const kCartListData_Url = @"car/selectByUserIdCarList";

@interface SmallShopCartListViewModel ()
@property (nonatomic,strong) NSMutableArray *saveOldArrChangeNewArr;

@end

@implementation SmallShopCartListViewModel

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
            self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithArray: [SmallShopCartListModel mj_objectArrayWithKeyValuesArray:arr]];
            self.dataOfArr = [[NSArray alloc]initWithArray:arr];
            //
            if(arr.count>0){
                self.showMsgStr = @"获取成功";
                self.pageNum += 1;
            }else{
                self.showMsgStr = @"";//@"暂无数据"; 在清空购物车做结算时也会提示 用空文本即可
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
            [self.saveOldArrChangeNewArr  addObjectsFromArray: [SmallShopCartListModel mj_objectArrayWithKeyValuesArray:arr]];
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

- (void)getNetDataWithPageNum:(NSInteger)willGetPageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{

    NSDictionary *parms = @{
        @"storeId": [SmallShopNowShopShare share].saveNowShopId,
        @"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID),
        @"page":@(self.pageNum),
        @"rows":@(Y_PAGE_SIZE_10)
    };
    
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,Cart_Url,kCartListData_Url] withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
   
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


+ (void)getCartListNumCountWithBlock:( void(^)(NSInteger nowCartGoosNum ,BOOL success) )block{
    NSDictionary *parms = @{
        @"storeId": [SmallShopNowShopShare share].saveNowShopId,
        @"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID),
        @"page":@(1),
        @"rows":@(99999)
    };
    
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,Cart_Url,kCartListData_Url] withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
   
         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSDictionary *dataDic = Y_ResponsObject_dataDic;
                 NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                 block(getArrs.count,YES);
             }else{
                 block(0,NO);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     Y_SVP_SHOW_ERR_MESSAGE
                 });
             }
         }else{
             block(0,NO);
             dispatch_async(dispatch_get_main_queue(), ^{
                 Y_SVP_SHOW_ERR_DESCRIPTION
             });
         }
     }];
  
}



@end
 
