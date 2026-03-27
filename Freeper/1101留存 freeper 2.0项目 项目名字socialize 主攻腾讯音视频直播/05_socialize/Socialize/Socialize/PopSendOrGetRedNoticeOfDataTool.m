//
//  PopSendNoticeOfDataTool.m
//  Socialize
//
//  Created by 余莹 on 2023/9/15.
//

#import "PopSendOrGetRedNoticeOfDataTool.h"

@implementation PopSendOrGetRedNoticeOfDataTool


#pragma mark ===
/**
 币种列表数据 总 getDic == {
    contract = "[{\"chainCode\":\"evm_bsc_97_test\",\"contractAddress\":\"0xc026606FF35c50e26E18d9908df879B8a49857e7\",\"decimals\":18,\"heat\":99,\"icon\":\"https://source.freeper.io/icon/f-u.png\",\"id\":1,\"isBuy\":0,\"name\":\"FFF\",\"symbol\":\"F-U\"},{\"chainCode\":\"evm_bsc_97_test\",\"contractAddress\":\"0xb366b91306F06399829De3575c6B237aEDBEe475\",\"decimals\":18,\"heat\":99,\"icon\":\"https://source.freeper.io/icon/fusdt.png\",\"id\":2,\"isBuy\":0,\"name\":\"UUUU\",\"symbol\":\"FUSDT\"},{\"chainCode\":\"evm_mmc_79\",\"contractAddress\":\"0xC0679a3372eC4273150b93Cc535a644B15870663\",\"decimals\":18,\"heat\":99,\"icon\":\"https://source.freeper.io/icon/usd-mc.png\",\"id\":3,\"isBuy\":0,\"name\":\"USD-MC\",\"symbol\":\"USD-MC\"}]";
  
    network = "[{\"chainCode\":\"evm_bsc_97_test\",\"chainId\":97,\"decimals\":18,\"icon\":\"https://source.freeper.io/icon/bnb.png\",\"id\":1,\"manageAddress\":\"0xA03804720e7B0f0244bc39bD6ABe48097d1ca504\",\"name\":\"BNB Smart Chain\",\"rpcUrl\":\"https://bsc-testnet.nodereal.io/v1/af5a90bdee9740ed8cbd645c593ca727\",\"shortName\":\"bnb\",\"symbol\":\"BNB\"},{\"chainCode\":\"evm_mmc_79\",\"chainId\":79,\"decimals\":18,\"icon\":\"https://source.freeper.io/icon/mmc.png\",\"id\":2,\"manageAddress\":\"0xF6ec9Ce77bB586fbA62EE65449f31A3d46c48A4F\",\"name\":\"Mix Max\",\"rpcUrl\":\"https://chain.mixmax.cc\",\"shortName\":\"MMC\",\"symbol\":\"MC\"}]";
   
    wallet =     (
                {
            address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
            balance = 1132904685081120440253;
            contractAddress = 0xc026606ff35c50e26e18d9908df879b8a49857e7;
            frozen = 0;
            id = 651446;
            rowCreate = "2023-09-16 10:04:02";
            rowUpdate = "2023-09-28 07:34:39";
            state = 1;
        }
    );
}
 
 */
+ (void)redEnvGetWalletListWithBolock:(BaseListArrAndSuccessBoolBlock)block{
    
    NSString *url = Y_AllURL_Main(URL_My_wallet_list);
    [[Y_NetWorkBaseTool sharedTool] YYrequestALLURLGetNotMainQueue:url
                                                        withParams:@{}.mutableCopy
                                                           finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSDictionary *getDic = Y_ResponsObject_dataDic;
                NSLog(@"币种列表数据 总 getDic == %@",getDic);//根据 contract的chainCode 分组显示哈，名称在network里
                NSString *wallet_K = @"wallet";
                NSString *contract_K = @"contract";
                NSString *network_K = @"network";
                NSMutableArray *arr_wallet = ( [[getDic allKeys] containsObject:wallet_K] && isNotNil([getDic objectForKey:wallet_K]) ) ? [getDic objectForKey:wallet_K] : [NSMutableArray array];
                NSMutableArray *arr_contract =  ( [[getDic allKeys] containsObject:contract_K] && isNotNil([getDic objectForKey:contract_K]) ) ? [getDic objectForKey:contract_K] : [NSMutableArray array];
                NSMutableArray *arr_network =  ( [[getDic allKeys] containsObject:network_K] && isNotNil([getDic objectForKey:network_K]) ) ? [getDic objectForKey:network_K] : [NSMutableArray array];
               
                if([arr_contract isKindOfClass:[NSString class]]){
                    arr_contract  = [NSMutableArray arrayWithArray: [Y_ToolOfOthers arrWithJson: [getDic objectForKey:contract_K]]];
                }
                if([arr_network isKindOfClass:[NSString class]]){
                    arr_network  = [NSMutableArray arrayWithArray: [Y_ToolOfOthers arrWithJson: [getDic objectForKey:network_K]]];
                }
                NSLog(@"我的钱包余额列表 %@ \n ,arr_network= %@ \n 合约信息 %@",arr_wallet,arr_network,arr_contract);
                NSArray *typeListAndWalletInfoArr = @[arr_contract,arr_network,arr_wallet];//类型 + 钱包 1007增类型数据
                block(typeListAndWalletInfoArr ,YES);
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



#pragma mark ===
//红包 创建 抢红包 详情

+ (void)redEnvCreateWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = Y_AllURL_Main(URL_redEnvelope_create);
    [[Y_NetWorkBaseTool sharedTool] YrequestPostALLURLNoMainQueueWithBodyNotParms:url
                                                                         withBody:parms
                                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
 /** 单聊发送的时候 拿到channelId 要给到后续接口
  YrequestPostALLURLNoMainQueueWithBodyNotParms Reply JSON: {
     data =     {
         address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
         category = 2;
         channelId = ulzwwyPSkOcDQ;
         contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
         cover = "https://c-ssl.dtstatic.com/uploads/blog/202203/21/20220321204722_1fa16.thumb.1000_0.jpg";
         expireTs = 1695095134241;
         id = 3;
         pieces = 1;
         scene = 0;
         senderMsg = "aaaaaaaaaa.free";
         title = "恭喜发财，大吉大利";
         total = 50;
         uno = 20230918034534223502886;
         wid = 651446;
     };
     message = success;
     status = 200;
     timestamp = 1695008734270;
 } https://test.freeper.l-z.vip:61125/auth/redEnvelope/create
  */
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}


+ (void)redEnvSnatchWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = Y_AllURL_Main(URL_redEnvelope_snatch);
    [[Y_NetWorkBaseTool sharedTool] YYrequestALLURLGetNotMainQueue:url
                                                         withParams:parms
                                                           finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                block(responsObject,NO);
                //此处走UI显示不走弹出框
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    Y_SVP_SHOW_ERR_MESSAGE
//                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
    
    /**
     https://test.freeper.l-z.vip:61125/auth/redEnvelope/snatch____{
        data =     {
            gotRecord =         (
                            {
                    address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
                    domain = "aaaaaaaaaa.free";
                    gotAmount = 2;
                    imId = ueVPpA2rSrKnT;
                    lifeImages = "";
                    profileImageUrl = "https://test.freeper.l-z.vip:61131/avatar/2023-08/5/1jFW9OF_720_543_32751_gmi.jpg";
                    username = "";
                }
            );
            redEnvelope =         {
                address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
                category = 0;
                channelId = csGPjHpV9COT;
                contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
                cover = "https://c-ssl.dtstatic.com/uploads/blog/202203/21/20220321204722_1fa16.thumb.1000_0.jpg";
                expireTs = 1695111079926;
                gotAmount = 0;
                gotCount = 0;
                id = 19;
                pieces = 1;
                rowCreate = "2023-09-18 08:11:19";
                rowUpdate = "2023-09-18 08:11:19";
                scene = 0;
                senderMsg = "aaaaaaaaaa.free";
                state = 0;
                title = "恭喜发财，大吉大利";
                total = 31;
                uno = 20230918081119910829700;
                wid = 651446;
            };
        };
        message = success;
        status = 200;
        timestamp = 1695090366980;
     */
    
}


+ (void)redEnvDetailWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = Y_AllURL_Main(URL_redEnvelope_detail);
    [[Y_NetWorkBaseTool sharedTool] YYrequestALLURLGetNotMainQueue:url
                                                         withParams:parms
                                                           finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}


//打赏主播
+ (void)redEnvLiveRewardWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = Y_AllURL_Main(URL_redEnvelope_liveReward);
    [[Y_NetWorkBaseTool sharedTool] YrequestPostALLURLNoMainQueueWithBodyNotParms:url
                                                                         withBody:parms
                                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}


//非余额度url 舍弃
+ (void)checkMyHaveBalanceWithBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = Y_AllURL_Main(URL_getMyBalance);
    [[Y_NetWorkBaseTool sharedTool] YYrequestALLURLGetNotMainQueue:url
                                                        withParams:@{}.mutableCopy
                                                           finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}

@end


#pragma mark ===

@implementation RedEvnInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

 


#pragma mark == 抢到红包后
@implementation RedEvn_gotRecordArrObjModel

@end
 
@implementation  RedEvn_gotRecordDataModel
//[RedEvn_gotRecordArrObjModel class]
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redEnvelope" : [RedEvnInfoModel class],
    };
}

@end
