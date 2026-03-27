//
//  BillingListDataVm.m
//  Community
//
//  Created by 余莹 on 2022/6/9.
//

#import "BillingListDataVm.h"
#import "BillingListModel.h"

#define  data_records_Key                 @"childData"

static NSString *const kBillingListData_Url = @"zhsj/base/api/trade/getTradeList";


@interface BillingListDataVm ()
 
@property (nonatomic,strong) NSMutableArray *saveOldArrChangeNewArr;
@property (nonatomic,strong) NSString *saveQueryTimeStr;
@property (nonatomic,assign) NSInteger saveType; 

@end
@implementation BillingListDataVm


- (void)fillQueryTimeStr:(NSString *)queryTimeStr andType:(NSInteger)type{
    self.saveQueryTimeStr = queryTimeStr;
    self.saveType = type;
}


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


- (void)getDataListOnePage{//第一页数据 空数据也要赋值到data用于筛选情况下的刷新
    self.pageNum = 1;
    [self getNetDataWithPageNum:1 withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
          
            if(arr.count>0){
                self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithArray: [BillingListModel mj_objectArrayWithKeyValuesArray:arr]];
                self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                //
                self.showMsgStr = @"获取成功";
                self.pageNum += 1;
            }else{
                self.dataOfArr = [[NSArray alloc]init];
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
            [self.saveOldArrChangeNewArr  addObjectsFromArray: [BillingListModel mj_objectArrayWithKeyValuesArray:arr]];
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
        @"page":@(self.pageNum),
        @"size":@(Y_PAGE_SIZE_10),
        @"type": @(self.saveType),
        @"queryTime" : self.saveQueryTimeStr
    };
    WEAKSELF
    NSString *listUrl =  [NSString stringWithFormat:@"%@%@",BASE_URL_OnlyAsOfPort,kBillingListData_Url];
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:listUrl withBody:parms.mutableCopy finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSDictionary *dataDic = Y_ResponsObject_dataDic;
                 
//                 if (isNotNil(weakSelf.moneyStrBlock)) {
//                     if  ([[dataDic allKeys] containsObject:@"payTotalAmount"] && isNotNil([dataDic objectForKey:@"payTotalAmount"]) )  {
//                         NSString *strOfMoney = [TextShowWithModelStr textShowWithModelStr:[dataDic objectForKey:@"payTotalAmount"]];
//                         if (strOfMoney.length==0) {
//                             weakSelf.moneyStrBlock(@"0.00");
//                         }else{
//                             weakSelf.moneyStrBlock(strOfMoney);
//                         }
//                     }else{
//                         weakSelf.moneyStrBlock(@"0.00");
//                     }
//                 }//单月的总金额的数据 等更改后的
               
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
