//
//  LdleGoodsListViewModel.m
//  Community
//
//  Created by 余莹 on 2022/6/21.
//

#import "LdleGoodsListViewModel.h"
#import "LdleGoodsModel.h"

static NSString *kUrl_activity_list   = @"proprietor/market/selectMarketPage";
static NSString *data_list_Key        = @"records";


@interface LdleGoodsListViewModel ()
@end

@implementation LdleGoodsListViewModel

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
            self.saveOldArrWithWillChangBaseArr = [[NSMutableArray alloc]initWithArray: [LdleGoodsModel mj_objectArrayWithKeyValuesArray:arr]];
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
            [self.saveOldArrWithWillChangBaseArr  addObjectsFromArray: [LdleGoodsModel mj_objectArrayWithKeyValuesArray:arr]];
            self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrWithWillChangBaseArr];
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
    NSInteger state = 0;
    if (self.typeState == LdleGoods_Type_Down  ) {
        state = 0;
    }else if (self.typeState == LdleGoods_Type_Up ){
        state = 1;
    }
    
    NSDictionary *parms = @{
        @"state":@(state),
        @"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID),
        @"page":@(self.pageNum),
        @"size":@(Y_PAGE_SIZE_10)
    };
    
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:Y_BASEURL(kUrl_activity_list) withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {

         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSDictionary *dataDic = Y_ResponsObject_dataDic;
                 NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_list_Key] && isNotNil([dataDic objectForKey:data_list_Key]) ) ? [dataDic objectForKey:data_list_Key] : [NSMutableArray array];
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
