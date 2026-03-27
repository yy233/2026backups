//
//  LifeCostData.m
//  Community
//
//  Created by 余莹 on 2022/1/4.
//

#import "LifeCostData.h"

 
#define URL_MainVcHuHaoList           @"proprietor/livingExpensesGroup/v2/accountList" //户号列表

#define URL_CityNameChangeCityName    @"proprietor/common/v2/getRegionName"  //城市名字转换后续可用的城市名字 (通过名称获取完整城市名称)

#define URL_CostTypeList              @"payment/cebBank/v2/cityContributionCategory"  //查询缴费类别

#define URL_CostProject               @"payment/cebBank/v2/queryContributionProject"  //查询缴费项目 (缴费公司列表)

//历史记录
#define URL_GetPayOrderList           @"proprietor/livingExpensesOrder/v2/orderList"  //查询缴费记录列表
#define URL_GetPayOrderDetail         @"proprietor/livingExpensesOrder/v2/orderDetail" //询生活缴费记录详情

//待支付
#define URL_GetWillPayOrderList                 @"proprietor/livingExpensesBill/v2/queryBillList" //查询账单列表
#define URL_GetWillPayOrderDetail               @"proprietor/livingExpensesBill/v2/queryBillInfo" // 查询账单详情 查询缴纳类型
#define URL_GetWillPayOrderDetail_PhoneNumType  @"payment/cebBank/v2/queryPaymentInfo"  // 查询账单详情 直缴详情 （手机号缴费）

//立即缴费
#define URL_PayAction                           @"proprietor/livingExpensesOrder/v2/addOrder"

@implementation LifeCostData
#pragma mark == 主页总

#pragma mark === 主页 户号列表
+ (void)lifeCostGetMainWithMinHuHaoSectionListWithArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_MainVcHuHaoList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
#pragma mark === 主页新增缴费相关
+ (void)lifeCostGetMainWithPayTypeListWithArrBlock:(BaseListArrAndSuccessBoolBlock)payTypeListblock{
    [self liftCityNameInitUpDateWithBlock:^(NSString * _Nonnull saveNowCityName, BOOL success) {
        if (success) {
        }else{
            if ([LifeCostSaveCityInfoModel share].cityName.length>0) {
                saveNowCityName = [LifeCostSaveCityInfoModel share].cityName;//旧的存的
            }
        }
        if (saveNowCityName.length<=0) {
            return;
        }
        [self lifeCostGetOneCity:saveNowCityName withPayTypeListWithArrBlock:payTypeListblock];
    }];
    
    
}
#pragma mark == 高德原生 拿到当前地址城市名
+ (void)liftCityNameInitUpDateWithBlock:(LifeCostSaveCityInfoBlock)block{
    WEAKSELF
    __block NSString *nowCityNameStr  = @"";
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (!error) {
            nowCityNameStr  = [TextShowWithModelStr textShowWithNotNullStr:model.locality];
        }else{
            Y_SVP_SHOW_ERR_MES(@"未获取到当前城市信息，采用默认城市");
            nowCityNameStr = @"重庆";
        }
        [weakSelf useCityNameStr:nowCityNameStr withUpdataSaveCityNameStrWithBlock:block];
    }];
}

#pragma mark == 城市名字转换 用定位的城市数据 拿到后台能用的城市数据 用于后续 [LifeCostSaveCityInfoModel]
+ (void)useCityNameStr:(NSString *)cityNameStr withUpdataSaveCityNameStrWithBlock:(LifeCostSaveCityInfoBlock)block{
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:cityNameStr forKey:@"regionName"];
   // NSString *url = [NSString stringWithFormat:@"%@?regionName=%@",URL_CityNameChangeCityName,cityNameStr];
//    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_CityNameChangeCityName withBody:parms finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_CityNameChangeCityName withParams:parms  finished:^(id responsObject, NSError *error) {
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_CityNameChangeCityName withParams:parms  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                NSLog(@"LifeCostSaveCityInfoModel 1 %@",[LifeCostSaveCityInfoModel share].cityName);
                NSString *saveNowCityName  = Y_ResponsObject_dataStr;
                [LifeCostSaveCityInfoModel share].cityName = saveNowCityName;
                NSLog(@"LifeCostSaveCityInfoModel 2 %@",[LifeCostSaveCityInfoModel share].cityName);
                block(saveNowCityName,YES);
            }else{
                [LifeCostSaveCityInfoModel share].cityName = @"";
                block(@"",NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            [LifeCostSaveCityInfoModel share].cityName = @"";
            block(@"",NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
 
}

#pragma mark == 查询缴费类别
+ (void)lifeCostGetOneCity:(NSString *)cityNameStr withPayTypeListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:cityNameStr forKey:@"cityName"];
    [parms setValue:@(2) forKey:@"deviceType"];//1-PC个人电脑2-手机终端3-微信公众号4-支付宝5-微信小程序
   // [parms setValue:@"北京市" forKey:@"cityName"];//test
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_CostTypeList withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *getDataDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                
                NSDictionary *getModelkDic = ( [[getDataDic allKeys] containsObject:@"paymentCitiesForClientModel"] && isNotNil([getDataDic objectForKey:@"paymentCitiesForClientModel"]) ) ? [getDataDic objectForKey:@"paymentCitiesForClientModel"] : [NSDictionary dictionary];
                
                NSMutableArray *listArr = ( [[getModelkDic allKeys] containsObject:@"cebPaymentCategoriesList"] && isNotNil([getModelkDic objectForKey:@"cebPaymentCategoriesList"]) ) ? [getModelkDic objectForKey:@"cebPaymentCategoriesList"] : [NSMutableArray array];
                
                block(listArr,YES);
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
#pragma mark == 主页 某种缴费类别 点击跳转市调用本接口 拿到类型数据 做不同界面的跳转。 查询缴费项目
+ (void)lifeCostGetOneCityAddGoToVcTypeWithCityPayTypeNum:(NSInteger)cityType withCityName:(NSString *)cityNameStr withCostProjectListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block{
    //;
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:cityNameStr forKey:@"cityName"];
    [parms setValue:@(2) forKey:@"deviceType"];//1-PC个人电脑2-手机终端3-微信公众号4-支付宝5-微信小程序
    [parms setValue:@(cityType) forKey:@"type"];//缴费类型
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_CostProject withBody:parms finished:^(id responsObject, NSError *error) {
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


#pragma mark === 切换城市 | 保存新的城市名 做主页的缴费类型列表请求用于切换后的UI更新
+ (void)lifeCostChangeCityWithChooseNameStr:(NSString *)changeNameStr withGetNewPayTypeListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block{
    [LifeCostSaveCityInfoModel share].cityName = changeNameStr;
    [self lifeCostGetOneCity:changeNameStr withPayTypeListWithArrBlock:block];
    
}



#pragma mark == 缴费记录
//初始查
+ (void)lifeCostGetPayOrderListWithPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block{
    [self lifeCostGetPayHistoryOrderListWithParms:nil withListBlock:block];
}
//分类型查
+ (void)lifeCostGetPayOrderListWithTypeIdStr:(NSString *)typeIdStr withPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:typeIdStr forKey:@"typeId"];
    [self lifeCostGetPayHistoryOrderListWithParms:parms withListBlock:block];
}
//用时间查
+ (void)lifeCostGetPayOrderListWithQueryTimeStr:(NSString *)queryTimeStr withPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    queryTimeStr = [queryTimeStr stringByAppendingString:@"-01"];//年-月-01的格式才能正常拿到数据
    [parms setValue:queryTimeStr forKey:@"queryTime"];
    [self lifeCostGetPayHistoryOrderListWithParms:parms withListBlock:block];
}
//类型+时间
+ (void)lifeCostGetPayOrderListWithTypeIdStr:(NSString *)typeIdStr
                                andQueryTimeStr:(NSString *)queryTimeStr
                withPayHistoryOrderListBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:typeIdStr forKey:@"typeId"];
    queryTimeStr = [queryTimeStr stringByAppendingString:@"-01"];//年-月-01的格式才能正常拿到数据
    [parms setValue:queryTimeStr forKey:@"queryTime"];
    [self lifeCostGetPayHistoryOrderListWithParms:parms withListBlock:block];
}
 //总
+ (void)lifeCostGetPayHistoryOrderListWithParms:(NSMutableDictionary *)parms withListBlock:(BaseListArrAndSuccessBoolBlock)block{
    if (isNil(parms)) {
        parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_GetPayOrderList withBody:parms finished:^(id responsObject, NSError *error) {
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
//缴费记录详情
+ (void)lifeCostGetPayHistoryOrderDetailWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:idStr forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_GetPayOrderDetail withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
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

#pragma mark == 缴费公司列表查询    //搜索字段 后台做不了
+ (void)lifeCostGetPayCompanyListWithTypeIdStr:(NSString *)typeIdStr
                               andCityNameStr:(NSString *)cityNameStr
                              andSearchTextStr:(NSString *)searchTextStr
                          withCompanyListBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [parms setValue:@"1" forKey:@"deviceType"];//默认值
    [parms setValue:typeIdStr forKey:@"type"];
    [parms setValue:cityNameStr forKey:@"cityName"];
 
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_CostProject withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *getDataDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSDictionary *itemModelDic = ( [[getDataDic allKeys] containsObject:@"paymentItemPagingModel"] && isNotNil([getDataDic objectForKey:@"paymentItemPagingModel"]) ) ? [getDataDic objectForKey:@"paymentItemPagingModel"] : [NSDictionary dictionary];
                //pagesize  "pageInfo"
                //cimpany
                NSMutableArray *listArr = ( [[itemModelDic allKeys] containsObject:@"paymentItemModelList"] && isNotNil([itemModelDic objectForKey:@"paymentItemModelList"]) ) ? [itemModelDic objectForKey:@"paymentItemModelList"] : [NSMutableArray array];
                block(listArr,YES);
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

- (void)savedata{
    /**
     

    url=payment/cebBank/v2/queryContributionProject Reply JSON: {
        code = 0;
        data =     {
            paymentItemPagingModel =         {
                cityModel =             {
                    categoryId = 0;
                    categoryType = 0;
                    cityCode = 010;
                    cityFlag = b;
                    cityId = 103300;
                    cityName = "北京市";
                    provinceId = 103300;
                };
                listPageModelList =             (
                );
                pageInfo =             {
                    currentPage = 1;
                    currentRec = 0;
                    nextPage = 0;
                    nextRec = 0;
                    pageSize = 2;
                    prePage = 0;
                    stRec = 0;
                    totalPage = 0;
                    totalReco = 2;
                };
                paymentItemModelList =             (
                                    {
                        businessFlow = 2;
                        categoryId = 32;
                        cebPaymentNameModelList =                     (
                        );
                        cityModelList =                     (
                        );
                        companyId = 010001302;
                        companyName = "测试案例-北京智能电表";
                        createPaymentBillParamsModelList =                     (
                                                    {
                                amountLimit = "0-100000";
                                payCondId = 146302;
                                payTimeTips = "营业时间为8:00-23:59";
                                paymentItemId = 110205;
                                rangLimit = "-10";
                            }
                        );
                        description = "二次查缴";
                        isAppoint = 1;
                        paymentBillFieldsInfoModelList =                     (
                        );
                        paymentItemCode = 161125633;
                        paymentItemId = 110205;
                        paymentItemName = "北京智能电表";
                        paymentItemNo = 001302;
                        queryPaymentBillParamModelList =                     (
                                                    {
                                description = "仅支持用户编号不支持条形码或二维码";
                                filedNum = 0;
                                filedType = 0;
                                inputType = "-1";
                                isNull = 0;
                                isScan = 0;
                                keyboardType = 0;
                                maxFieldLength = 20;
                                minFieldLength = 10;
                                name = "用户编号";
                                paymentItemId = 110205;
                                priorLevel = 1;
                                selectParamId = 151804;
                                showLevel = 1;
                                type = 0;
                            }
                        );
                        status = 1;
                        tempOffStatus = 0;
                    },
                                    {
                        businessFlow = 0;
                        categoryId = 32;
                        cebPaymentNameModelList =                     (
                        );
                        cityModelList =                     (
                        );
                        companyId = 010001301;
                        companyName = "国网北京市电力公司";
                        createPaymentBillParamsModelList =                     (
                                                    {
                                amountLimit = "0-1000000000000";
                                payCondId = 229704;
                                paymentItemId = 246907;
                                rangLimit = 1;
                            }
                        );
                        isAppoint = 1;
                        paymentBillFieldsInfoModelList =                     (
                        );
                        paymentItemCode = 987745741;
                        paymentItemId = 246907;
                        paymentItemName = "北京网络电表代缴（勿删）";
                        paymentItemNo = 001301;
                        printAddress = "交易日起三个月内凭光大银行缴费凭条到国网电力网点换取发票";
                        queryPaymentBillParamModelList =                     (
                                                    {
                                description = "购电金额200，单位：元";
                                filedNum = 2;
                                filedType = 1;
                                inputType = 1;
                                isNull = 0;
                                isScan = 0;
                                keyboardType = 3;
                                listBoxOptions = "200=200";
                                maxFieldLength = 999;
                                minFieldLength = 0;
                                name = "购电金额";
                                paymentItemId = 246907;
                                priorLevel = 2;
                                selectParamId = 251307;
                                showLevel = 2;
                                type = 0;
                            },
                                                    {
                                description = "10位至12位数字用户编号";
                                filedNum = 0;
                                filedType = 0;
                                inputType = "-1";
                                isNull = 0;
                                isScan = 0;
                                keyboardType = 2;
                                maxFieldLength = 12;
                                minFieldLength = 10;
                                name = "用户编号";
                                paymentItemId = 246907;
                                priorLevel = 1;
                                selectParamId = 242506;
                                showLevel = 1;
                                type = 0;
                            }
                        );
                        status = 1;
                        tempOffStatus = 0;
                    }
                );
            };
        };
        message = "<null>";
    }

     
     */
    
}

#pragma mark == 待支付 账单列表
+ (void)lifeCostGetWillPayOrderListWithMyAccoundBillKeyStr:(NSString *)billKeyStr withListBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:billKeyStr forKey:@"billKey"];//户号
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_GetWillPayOrderList withBody:parms finished:^(id responsObject, NSError *error) {
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

#pragma mark == 待支付 账单详情
+ (void)lifeCostGetWillPayOrderDetailWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{

    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:idStr forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_GetWillPayOrderDetail withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
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
#pragma mark == 待支付 直缴详情 （手机号缴费）api/v1/payment/cebBank/v2/queryPaymentInfo
+ (void)lifeCostGetWillPayOrderDetailWithPayTypeId:(NSString *)payTypeIdStr withPhotoNumStr:(NSString *)photoNumStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:payTypeIdStr forKey:@"categoryType"];
    [parms setValue:photoNumStr forKey:@"mobile"];
    [parms setValue:@(2) forKey:@"deviceType"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_GetWillPayOrderDetail_PhoneNumType withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
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

#pragma mark == 立即缴费
+ (void)lifeCostPayOrderActionWithBodyDic:(NSMutableDictionary *)bodyDic withDlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_PayAction withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
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

#pragma mark == 在h5调用微信等app 缴完费或者放弃缴费后 (回到本app) 做查询当前订单状态信息 得到状态 用于跳转后续的成功失败界面
+ (void)lifeCostCheckOrderNoStr:(NSString *)orderNoStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    //20220418不能查待支付详情 需要改成查当前订单的缴费记录拿到对应状态做提示
    [self lifeCostGetPayHistoryOrderDetailWithIdStr:orderNoStr withBlock:block];
    
}
@end
