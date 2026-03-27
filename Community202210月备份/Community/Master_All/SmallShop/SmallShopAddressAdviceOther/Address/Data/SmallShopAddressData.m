//
//  SmallShopAddressData.m
//  Community
//
//  Created by 余莹 on 2022/3/11.
//

#import "SmallShopAddressData.h"
#import "MyHouseData.h"
#import "MyHouseCerEdHouseModel.h" //#import "MyHouseRelationMeAllTypeHouseModel.h"

static NSString *URL_selectAddressList = @"address/selectAddressList"; //查询用户历史地址记录
static NSString *URL_AddAddress        = @"address/addressUpdate"; // 增加地址
static NSString *URL_deletAddress      = @"address/deletedAddress"; // 删除地址
static NSString *URL_useThisAddress    = @"address/useAddress";//使用此地址
 

@implementation SmallShopAddressData

/**
 查询 优先级
 share 有地址，直接返回。   ｜ share内无地址 以下请求：
 小店有地址列表数据则拿list_first ,不去请求社区｜
 小店地址列表无数据，去请求社区的list取first  |
 
 ---> 保存到share
 
 
 新增｜使用  优先级
 新增或使用    ---> 保存到share （更新最新的一个地址 做常用地址
 
 删除。对比share内是同一个  ---> 删除share 做查询l流程操作再存入share
 
 
 */
 
#pragma mark ==== 总查询 先小店f｜无则社区f 得到默认地址
+ (void)smallShopNomalFirstAddressAndPhoneWithBlock:(SmallShopAddressInfoBlock)block{
    //初始
    if (isNil([SmallShopAddressShare share].nomallAddressInfoModel)) {
        [SmallShopAddressShare share].nomallAddressInfoModel = [[SmallShopAddressInfoModel alloc]init];
    }
    //数据获取
    if ([SmallShopAddressShare share].nomallAddressInfoModel.detail.length>0) {//存储的
        NSLog(@"使用存储的地址信息");
        return block([SmallShopAddressShare share].nomallAddressInfoModel ,YES);
        
    }else{
        [self smallShopAddressInfoHaveUsedListGetFirstAddresAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {//小店用过的或者新增的
            if (isHaveBool) {
                NSLog(@"使用小店用过的或者新增的的地址信息");
                [self samllShopAddressShareInfoSaveWithModel:addressInfoModel];//保存share
                return block( addressInfoModel ,YES);
                
            }else{
                [self smallShopNotAddressInfoWithLookNowCommunityFirstHouseAddressAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {//社区first
                    if (isHaveBool) {
                        NSLog(@"使用社区first的地址信息");
                        [self samllShopAddressShareInfoSaveWithModel:addressInfoModel];//保存share
                        return block( addressInfoModel ,YES);
                        
                    }else{
                        addressInfoModel.detail = @"暂无地址信息";
                        addressInfoModel.phone = @"暂无电话信息";
                        return block (addressInfoModel,NO);//只展示使用｜不保存share
                    }
                     
                }];
            }
        }];
        
    }
     
}



//查询当前社区最优先级的地址
+ (void)smallShopNotAddressInfoWithLookNowCommunityFirstHouseAddressAndPhoneWithBlock:(SmallShopAddressInfoBlock)block{
    //getMyHousesHaveRelattionListWithBlock可有可无房的任意身份身份 //getMyHousesHaveBeenCertifiedListDataWithBlock 有房的身份
    [MyHouseData getMyHousesHaveRelattionListWithBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            if (arr.count <= 0) {
                SmallShopAddressInfoModel *modle = [[SmallShopAddressInfoModel alloc]init];
                return block(modle,NO);
            }else{
                NSDictionary *dic = arr.firstObject;
                MyHouseRelationMeAllTypeHouseModel *houseModel = [MyHouseRelationMeAllTypeHouseModel mj_objectWithKeyValues:dic];
                //
                SmallShopAddressInfoModel *modle = [[SmallShopAddressInfoModel alloc]init];
                modle.detail =  [ [TextShowWithModelStr textShowWithNotNullStr:houseModel.communityText] stringByAppendingString: [TextShowWithModelStr textShowWithNotNullStr:houseModel.houseSite] ];
                modle.phone = [TextShowWithModelStr textShowWithNotNullStr:[ShareUserInfo sharedUserInfo].userInfo.mobile];
                //
                [self samllShopAddressShareInfoSaveWithModel:modle];//保存share
                return block(modle,YES);//使用
        
            }
          
        }
    }];


}
//查询小店已添加或使用的地址列表 | 返回firstObj
+ (void)smallShopAddressInfoHaveUsedListGetFirstAddresAndPhoneWithBlock:(SmallShopAddressInfoBlock)block{
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:Y_SmallShop_URL_AllLongURL(URL_selectAddressList) withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        
        SmallShopAddressInfoModel *model = [[SmallShopAddressInfoModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {

                NSArray *getArrs = Y_ResponsObject_dataArr;
                if (getArrs.count <=0 ) {
                    block(model,NO);
                    
                }else{
                    model = [SmallShopAddressInfoModel mj_objectWithKeyValues:getArrs.firstObject];
                    block(model,YES);
                }
             }else{
                 block(model,NO);
            }
        }else{
            block(model,NO);
        }
        
    }];
}

#pragma mark ==== 保存share
+ (void)samllShopAddressShareInfoSaveWithModel:(SmallShopAddressInfoModel *)addressInfoModel{
    if (addressInfoModel.detail.length == 0) {
        return;
    }
    [SmallShopAddressShare share].nomallAddressInfoModel = addressInfoModel;
}

#pragma mark ====  列表
//查询小店已添加或使用的地址列表 | 返回列表
+ (void)smallShopAddressInfoHaveUsedListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:Y_SmallShop_URL_AllLongURL(URL_selectAddressList) withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}



#pragma mark ==== 新增
+ (void)smallShopAddressAddNewInfoModel:(SmallShopAddressInfoModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSDictionary *parms = @{
        @"detail":model.detail,
        @"phone":model.phone
    };
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(URL_AddAddress) withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [weakSelf samllShopAddressShareInfoSaveWithModel:model];//保存当前最新添加的地址 为默认地址    //save share
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
             
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ==== 删除

+ (void)smallShopAddressDeletOneInfoModel:(SmallShopAddressInfoModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block{
  //id body
    
    NSArray *body = @[
         model.ID
    ];
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(URL_deletAddress) withBody:body  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //save change Share
                if ([[SmallShopAddressShare share].nomallAddressInfoModel.detail isEqualToString:model.detail] &&  [[SmallShopAddressShare share].nomallAddressInfoModel.phone isEqualToString:model.phone]) {
                    [SmallShopAddressShare share].nomallAddressInfoModel = [[SmallShopAddressInfoModel alloc]init];//删除了当前默认的地址信息 则清空share
                    [weakSelf smallShopNomalFirstAddressAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {//获取最新默认并保存新share
                    }];
                }
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}


//使用地址修改顺序  
+ (void)smallShopAddressUseThisOneInfoModel:(SmallShopAddressInfoModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSDictionary *parms = @{
        @"addressId":model.ID,
    };
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:Y_SmallShop_URL_AllLongURL(URL_useThisAddress) withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //change share 最新默认并保存新share
                [SmallShopAddressShare share].nomallAddressInfoModel = model;
                block(Y_ResponsObject_dataDic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}
@end
