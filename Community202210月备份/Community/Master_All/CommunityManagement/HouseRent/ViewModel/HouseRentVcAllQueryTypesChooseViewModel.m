//
//  HouseRentVCTypeChooseViewModel.m
//  Community
//
//  Created by 余莹 on 2020/12/30.
//  筛选

#import "HouseRentVcAllQueryTypesChooseViewModel.h"

@implementation HouseRentVcAllQueryTypesChooseViewModel
+ (void)getCityQuArr:(BaseListArrAndSuccessBoolBlock)listArrBlock{
    [ShareUserInfo sharedUserInfo].commuityInfo.cityId = 500100;//test
    NSString *url = [NSString stringWithFormat:@"proprietor/common/region?queryType=1&regionNumber=%ld",(long)[ShareUserInfo sharedUserInfo].commuityInfo.cityId];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *arr = [NSArray arrayWithArray:Y_ResponsObject_dataArr];
                if (arr.count>0) {
                    block(arr,YES);
                }else{
                    block(@[],NO);
                }
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
#pragma mark ===租金
+ (void)getMoneyArr:(BaseListArrAndSuccessBoolBlock)listArrBlock{//一已经改成post请求
    NSArray *body = [NSArray arrayWithObject:@(5)];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr = [[reDic allKeys] containsObject:@"5"] ? [NSArray arrayWithArray:reDic[@"5"]] : [[NSArray alloc]init];
                if (arr.count>0) {
                    block(arr,YES);
                }else{
                    block(@[],NO);
                }
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
#pragma mark ===房屋类型
+ (void)getHouseTypeArr:(BaseListArrAndSuccessBoolBlock)listArrBlock{
    NSArray *body = [NSArray arrayWithObject:@(2)];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr = [[reDic allKeys] containsObject:@"2"] ? [NSArray arrayWithArray:reDic[@"2"]] : [[NSArray alloc]init];
                if (arr.count>0) {
                    block(arr,YES);
                }else{
                    block(@[],NO);
                }
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
#pragma mark ===更多
+ (void)getMoreArr:(BaseDicAndSuccessBoolBlock)dicArrBlock{//dic
    //出租常量接口相关数据更改 （ 12:: @"房屋亮点" （原本19）10:@"@"出租房源类型""(原本12)）
    //1015房屋更多筛选数据更改10 11 12
    NSArray *body = @[@(10),@(11),@(12)];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block  = dicArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSMutableDictionary *okdic = [NSMutableDictionary dictionary];
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arrKey = [NSArray arrayWithArray:[reDic allKeys]];
                //
//                NSArray *arrWithHouseSource = [arrKey containsObject:@"9"] ? [NSArray arrayWithArray:reDic[@"9"]] : [[NSArray alloc]init];//房屋来源
//                [okdic setValue:arrWithHouseSource forKey:@"房屋来源"];
                //
                NSArray *arrWithHouseType = [arrKey containsObject:@"10"] ? [NSArray arrayWithArray:reDic[@"10"]] : [[NSArray alloc]init];//租房类型
                [okdic setValue:arrWithHouseType forKey:@"租房类型"];
                //
                NSArray *arrWithRentType = [arrKey containsObject:@"11"] ? [NSArray arrayWithArray:reDic[@"11"]] : [[NSArray alloc]init];//租房方式
                [okdic setValue:arrWithRentType forKey:@"租房方式"];
                
                NSArray *arrWithHouseSource = [arrKey containsObject:@"12"] ? [NSArray arrayWithArray:reDic[@"12"]] : [[NSArray alloc]init];
                [okdic setValue:arrWithHouseSource forKey:@"房源亮点"];
                //
//                NSArray *arrWithHouseOtherType = [arrKey containsObject:@"12"] ? [NSArray arrayWithArray:reDic[@"12"]] : [[NSArray alloc]init];//出租房源类型
//                [okdic setValue:arrWithHouseOtherType forKey:@"出租房源类型"];
                block(okdic,YES);
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
#pragma mark ========================
#pragma mark ===租金
+ (void)getBuniessShopMoneyArr:(BaseListArrAndSuccessBoolBlock)listArrBlock{//一已经改成post请求
    NSArray *body = [NSArray arrayWithObject:@(5)];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr = [[reDic allKeys] containsObject:@"5"] ? [NSArray arrayWithArray:reDic[@"5"]] : [[NSArray alloc]init];
                if (arr.count>0) {
                    block(arr,YES);
                }else{
                    block(@[],NO);
                }
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
#pragma mark ===面积
+ (void)getBuniessAreaSpaceeArr:(BaseListArrAndSuccessBoolBlock)listArrBlock{
    NSArray *body = [NSArray arrayWithObject:@(6)];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr = [[reDic allKeys] containsObject:@"6"] ? [NSArray arrayWithArray:reDic[@"6"]] : [[NSArray alloc]init];
                if (arr.count>0) {
                    block(arr,YES);
                }else{
                    block(@[],NO);
                }
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
#pragma mark ===更多
+ (void)getBuniessMoreArr:(BaseDicAndSuccessBoolBlock)dicArrBlock{
//    NSArray *body = @[@(7),@(8),@(9)];
//    URL_Get_Rent_BuniessShop_ShaiXuan_MoreOption URL_Get_Rent_House_Const
    NSArray *body = @[];
//    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_BuniessShop_ShaiXuan_MoreOption withBody:body finished:^(id responsObject, NSError *error) {
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_Rent_BuniessShop_ShaiXuan_MoreOption withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        
        BaseDicAndSuccessBoolBlock block  = dicArrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSMutableDictionary *okdic = [NSMutableDictionary dictionary];
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                //
//                NSArray *arrKey = [NSArray arrayWithArray:[reDic allKeys]];
                //
//                NSArray *arrWithBuniessShopType = [arrKey containsObject:@"7"] ? [NSArray arrayWithArray:reDic[@"7"]] : [[NSArray alloc]init];//商铺类型
//                [okdic setValue:arrWithBuniessShopType forKey:@"商铺类型"];
//                //
//                NSArray *arrWithBuniessIndustry = [arrKey containsObject:@"8"] ? [NSArray arrayWithArray:reDic[@"8"]] : [[NSArray alloc]init];//商铺行业
//                [okdic setValue:arrWithBuniessIndustry forKey:@"商铺行业"];
//                //
//                NSArray *arrWithHouseSource = [arrKey containsObject:@"9"] ? [NSArray arrayWithArray:reDic[@"9"]] : [[NSArray alloc]init];//房屋来源
//                [okdic setValue:arrWithHouseSource forKey:@"房屋来源"];
                /*
                 business ---sub typeName = "商铺行业";
                 source =         (
                                 {
                         id = 1;
                         type = "业主";
                     },
                                 {
                         id = 2;
                         type = "物业";
                     },.......
                 type =         (
                                 {
                         constName = "不限";
                         createTime = "2021-01-12 13:36:39";
                         deleted = 0;
                         id = 1;
                         idStr = 1;
                         typeId = 2;
                         typeName = "商铺类型";
                     },......
                 business  type source
                **/
                block(reDic,YES);
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
