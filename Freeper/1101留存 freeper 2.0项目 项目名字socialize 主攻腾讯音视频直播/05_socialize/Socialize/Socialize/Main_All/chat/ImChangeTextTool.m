//
//  ImChangeTextTool.m
//  Socialize
//
//  Created by 余莹 on 2023/6/10.
//

#import "ImChangeTextTool.h"



@implementation  ImChangeTextUseContent_subParametersOrMyUser_Model

@end

@implementation ImChangeTextUseContentModel
 
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"detailsIdSSSS" : @"detailsId"};
}

@end

@implementation ImChangeTextUseMainModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content" : [ImChangeTextUseContentModel class]};
}
@end



@implementation ImChangeTextTool


+ (NSString *)changeImTextToolWithDic:(NSDictionary *)allDic{
    NSString *okStr = @"";
//    NSMutableDictionary *allDic = allDic.mutableCopy;
//    if([[allDic allKeys] containsObject:@"content"]){
//        if( [[allDic objectForKey:@"content"] isKindOfClass:[NSString class]]){
//            NSString *contentStr =  [allDic objectForKey:@"content"];
//            NSDictionary *contentStrDic = [Y_ToolOfOthers dictionaryWithJsonString:contentStr];
//            [allDic setValue:contentStrDic forKey:@"content"];
//        }
//    }
    
    ImChangeTextUseMainModel *mainModel =   [ImChangeTextUseMainModel mj_objectWithKeyValues:allDic];
    okStr = [TextShowWithModelStr textShowWithModelStr:mainModel.content.msg];//保留原本数据 ｜新类型时 直接展示 不为空
//    if([mainModel.msgType isEqualToString: @"txt"] && [mainModel.from isEqualToString:@"Service"]){//文本类型
    if([mainModel.msgType isEqualToString: @"txt"] && ([mainModel.from isEqualToString:@"Service"] || [mainModel.from isEqualToString:@"System"]) ){
        NSLog(@" changeImTextToolWithDic -- %@",allDic);
        if ([mainModel.content.category isEqualToString: @"SystemNotice"]) {//SystemNotice类型
            okStr = [ImChangeTextTool changeSystemNoticeContentIndex:mainModel.content.contentIndex];
        }else if([mainModel.content.category isEqualToString: @"MarketAuctionRecord"]){//直播通
            okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
        }else if([mainModel.content.category isEqualToString: @"ActivityMember"]){//
            okStr = [ImChangeTextTool changeActivityMemberContentIndex:mainModel.content.contentIndex];
            if([okStr containsString:@"%@"]){
                NSString*thisActivityTitle =  [[mainModel.content.parameters allKeys]containsObject:@"title"]? [NSString stringWithFormat:@"%@",[mainModel.content.parameters objectForKey:@"title"]] : @"";
                okStr  = [NSString stringWithFormat:okStr,thisActivityTitle];
            }                
        }else if([mainModel.content.category isEqualToString: @"Activity"]){//
            
            okStr = [ImChangeTextTool zhiBoActivityContentIndex:mainModel.content.contentIndex withContent:mainModel.content];
        }else if([mainModel.content.category isEqualToString: @"GroupCreated"]){
         
            okStr = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜您创建%@圈成功,快去邀请朋友加入吧!"),mainModel.content.category];
        }else if([mainModel.content.category isEqualToString: @"NftDomain"]){//
            okStr = [ImChangeTextTool nftActionRecordWithContent:mainModel.content];
        }else if([mainModel.content.category isEqualToString: @"MarketTradingRecord"]){//
            okStr = [ImChangeTextTool marketTradingRecordWithContent:mainModel.content];
        }else if([mainModel.content.category isEqualToString: @"MarketTradingPlatform"]){//
            okStr = [ImChangeTextTool marketTradingPlatformWithContent:mainModel.content];
            
        }else{
            okStr = mainModel.content.msg;
            NSLog(@"待处理的系统信息。%@",okStr)
            
        }
    }
    if(okStr.length<=0){
        okStr = @"---";
        NSLog(@"pods changeImTextToolWithDic allDic == %@",allDic);//未处理类型
    }
    
    
    return isNil(okStr) ? @"" : okStr;
}


+ (NSString *)changeSystemNoticeContentIndex:(NSInteger )contentIndex{
    NSString *okStr = @"";
    if(contentIndex == 1){//欢迎来到Freeper
        okStr = Y_LocaleTypeFile_NSLocalString(@"欢迎来到Freeper");// Y_LocaleTypeFile_NSLocalString(@"欢迎来到Freeper");
    }else  if(contentIndex == 0){//我们发布了最新版本,一起体验吧!
        okStr = Y_LocaleTypeFile_NSLocalString(@"我们发布了最新版本,一起体验吧!");// Y_LocaleTypeFile_NSLocalString(@"我们发布了最新版本,一起体验吧!");
    }else{
        okStr = Y_LocaleTypeFile_NSLocalString(@"系统公告");// Y_LocaleTypeFile_NSLocalString(@"系统公告");
    }
    
    return isNil(okStr) ? @"" : okStr;
}


+ (NSString *)changeMarketAuctionRecordContentIndex:(NSInteger )contentIndex{
    NSString *okStr = @"";
    if(contentIndex == 0){
        okStr = Y_LocaleTypeFile_NSLocalString(@"报价信息!");//"恭喜 {receiveAddress} 向您报价 {nftId}
    }else{
        okStr = Y_LocaleTypeFile_NSLocalString(@"交易通知");// Y_LocaleTypeFile_NSLocalString(@"欢迎来到Freeper");
    }
    
    return isNil(okStr) ? @"" : okStr;
}


/**
 
 }else if([mainModel.content.category isEqualToString: @"ActivityMember"]){//报价相关
 okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
 }else if([mainModel.content.category isEqualToString: @"Activity"]){//报价相关
 okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
 }else if([mainModel.content.category isEqualToString: @"GroupCreated"]){//报价相关
 okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
 }else if([mainModel.content.category isEqualToString: @"NftDomain"]){//报价相关
 okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
 }else if([mainModel.content.category isEqualToString: @"MarketTradingRecord"]){//报价相关
 okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
 }else if([mainModel.content.category isEqualToString: @"MarketTradingPlatform"]){//报价相关
 okStr = [ImChangeTextTool changeMarketAuctionRecordContentIndex:mainModel.content.contentIndex];
 
 */

+ (NSString *)changeActivityMemberContentIndex:(NSInteger )contentIndex{
    NSString *okStr = @"";
    if(contentIndex == 0){
        okStr =Y_LocaleTypeFile_NSLocalString(@"恭喜您报名%@直播成功,记得准时加入哦！"); //恭喜您报名{title}直播成功,记得准时加入哦！//Y_LocaleTypeFile_NSLocalString(@"报名直播成功!");
    }else{
        okStr = Y_LocaleTypeFile_NSLocalString(@"直播通知");
    }
    
    return isNil(okStr) ? @"" : okStr;
}

+ (NSString *)zhiBoActivityContentIndex:(NSInteger)contentIndex withContent:(ImChangeTextUseContentModel *)contenMode{
    
    NSString *okStr = @"";
    NSString *titL = [NSString stringWithFormat:@"%@",[contenMode.parameters objectForKey:@"title"]];
//    if(contentIndex == 2){
//        okStr = [NSString stringWithFormat:@"恭喜您报名{%@}直播成功,记得准时加入哦！",titL];
//    }else if(contentIndex == 3){
//        okStr =[NSString stringWithFormat:@"您参与的{%@} 直播开始了，快去观看吧！",titL];
//    }
    //0816去掉括号
    if(contentIndex == 2){
        okStr = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"恭喜您报名%@直播成功,记得准时加入哦！"),titL];
    }else if(contentIndex == 3){
        okStr =[NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"您参与的%@直播开始了，快去观看吧！"),titL];
    }
    
    return isNil(okStr) ? @"" : okStr;
}

#pragma mark === nft
+ (NSString *)nftActionRecordWithContent:(ImChangeTextUseContentModel *)contenMode{
    NSString *allSt = @"";
    /**
     "NftDomain": {
                         "0": {
                             "template": "恭喜 {ownerAddress} 注册FreeID {domain} 成功"
                         },
                         "1": {
                             "template": "恭喜 {ownerAddress} FreeID {domain} 上架成功"
                         },
                         "2": {
                             "template": "恭喜 {address} 向 {ownerAddress} 出售FreeID {domain} 成功"
                         },
                         "3": {
                             "template": "恭喜 {ownerAddress} 出售FreeID {domain} 成功"
                         },
                         "title": "交易通知"
     */
    
    ImChangeTextUseContent_subParametersOrMyUser_Model *subParametersModel = [ImChangeTextUseContent_subParametersOrMyUser_Model mj_objectWithKeyValues:contenMode.parameters];
    NSString *addressStr = subParametersModel.address.length>0 ? subParametersModel.address : @"";
    NSString *nftIdStr = subParametersModel.nftId.length>0 ? subParametersModel.nftId : @"";
    NSString *receiveAddressStr = subParametersModel.receiveAddress.length>0 ? subParametersModel.receiveAddress : @"";
    NSString *ownerAddressStr = subParametersModel.ownerAddress.length>0 ? subParametersModel.ownerAddress : @"";
    NSString *domainStr = subParametersModel.domain.length>0 ? subParametersModel.domain : @"";

    
   
    switch (contenMode.contentIndex) {
        case 0:
        {
            NSString *str = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜%@注册FreeID%@成功"),ownerAddressStr,domainStr];
            return  str;
        }
            break;
        case 1:
        {
  
            NSString *str = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"恭喜%@FreeID%@上架成功"),ownerAddressStr,domainStr];
            return  str;
        }
            break;
        case 2:
        {
       
            NSString *str = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"恭喜%@向%@出售FreeID%@成功"),addressStr,ownerAddressStr,domainStr];
            return  str;
        }
            break;
        case 3:
        {
            NSString *str = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"恭喜%@出售FreeID%@成功"),ownerAddressStr,domainStr];
            return  str;
        }
            break;
        default:
        {
            NSString *str =  Y_LocaleTypeFile_NSLocalString(@"交易通知");
            return  str;
        }
            break;
    }
    
    
    return allSt;
}


#pragma mark == MarketTradingPlatform

+ (NSString *)marketTradingPlatformWithContent:(ImChangeTextUseContentModel *)contenMode{
 
    
    ImChangeTextUseContent_subParametersOrMyUser_Model *subParametersModel = [ImChangeTextUseContent_subParametersOrMyUser_Model mj_objectWithKeyValues:contenMode.parameters];
 
    NSString *str = @"交易通知";
    NSString *gongXi = @"恭喜";
    NSString *chuSHou = @"出售";
    NSString *paimaichuSHou = @"拍卖出售";
    NSString *daoShiChang = @"到市场";
    NSString *chengGong = @"成功";
    NSString *shibai = @"失败";
    NSString *yihan = @"遗憾";
    NSString *baojia = @"报价";
    NSString *zengyu = @"赠予";
    NSString *dingxiang = @"定向销售";
    NSString *jinpai = @"竞拍";
    NSString *xiang = @"向";
    
    
    NSString *addressStr = subParametersModel.address.length>0 ? subParametersModel.address : @"";
    NSString *nftIdStr = subParametersModel.nftId.length>0 ? subParametersModel.nftId : @"";
    NSString *receiveAddressStr = subParametersModel.receiveAddress.length>0 ? subParametersModel.receiveAddress : @"";

//    switch (contenMode.state) {
//        case 0:
//        {
//            str = [NSString stringWithFormat:@"%@{%@}%@{%@}%@%@",gongXi,addressStr,chuSHou,nftIdStr,daoShiChang,chengGong];
//        }
//            break;
//        case 1:
//        {
//            str = [NSString stringWithFormat:@"%@{%@}%@{%@}%@%@",gongXi,addressStr,paimaichuSHou,nftIdStr,daoShiChang,chengGong];
//        }
//            break;
//        case 2:
//        {
//            str = [NSString stringWithFormat:@"{%@}%@{%@}",addressStr,baojia,nftIdStr];
//        }
//            break;
//        case 3:
//        {
//            str = [NSString stringWithFormat:@"%@{%@}%@{%@}%@{%@}%@",gongXi,addressStr,xiang,receiveAddressStr,zengyu,nftIdStr,chengGong];
//        }
//            break;
//        case 4:
//        {
//            str = [NSString stringWithFormat:@"%@{%@}%@{%@}%@{%@}%@",gongXi,addressStr,xiang,receiveAddressStr,dingxiang,nftIdStr,chengGong];
//
//        }
//            break;
//        default:
//            break;
//    }
    
    //0816去掉括号
    //0823多语言处理
    switch (contenMode.state) {
        case 0:
        {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@",gongXi,addressStr,chuSHou,nftIdStr,daoShiChang,chengGong];
           /**
            @"恭喜"
            %a
            @"出售"
            %b"
            @"到市场"
            @"成功"
            "*/
            
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜%@出售%@到市场成功") ,addressStr,nftIdStr];
            return textS;
            
        }
            break;
        case 1:
        {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@",gongXi,addressStr,paimaichuSHou,nftIdStr,daoShiChang,chengGong];
            /**
             @"恭喜"
             %a
             @"拍卖出售"
             %b"
             @"到市场"
             @"成功"
             "*/
             
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜%@拍卖出售%@到市场成功") ,addressStr,nftIdStr];
            return textS;
        }
            break;
        case 2:
        {
            str = [NSString stringWithFormat:@"%@%@%@",addressStr,baojia,nftIdStr];
            /**
             报价
             */
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"%@报价%@") ,addressStr,nftIdStr];
            return textS;
            
        }
            break;
        case 3:
        {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",gongXi,addressStr,xiang,receiveAddressStr,zengyu,nftIdStr,chengGong];
            /**
             @"恭喜"
             %a
             @"向"
             %b"
             @"@"赠予""
             nftIdStr
             @"成功"
             "*/
             
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜%@向%@赠予%@成功") ,addressStr,receiveAddressStr,nftIdStr];
            return textS;
        }
            break;
        case 4:
        {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",gongXi,addressStr,xiang,receiveAddressStr,dingxiang,nftIdStr,chengGong];
            /**
             @"恭喜"
             %a
             @"向"
             %b"
             @"@"赠予""
             nftIdStr
             @"成功"
             "*/
             
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜%@向%@定向销售%@成功") ,addressStr,receiveAddressStr,nftIdStr];
            return textS;

        }
            break;
        default:
            break;
    }

    return  str;
    
    
}


#pragma mark ===  MarketTradingRecord
+ (NSString *)marketTradingRecordWithContent:(ImChangeTextUseContentModel *)contenMode{
 
    
    ImChangeTextUseContent_subParametersOrMyUser_Model *subParametersModel = [ImChangeTextUseContent_subParametersOrMyUser_Model mj_objectWithKeyValues:contenMode.parameters];
 
    NSString *str = @"交易通知";
    NSString *gongXi = @"恭喜";
    NSString *chuSHou = @"出售";
    NSString *paimaichuSHou = @"拍卖出售";
    NSString *daoShiChang = @"到市场";
    NSString *chengGong = @"成功";
    NSString *shibai = @"失败";
    NSString *yihan = @"很遗憾";
    NSString *baojia = @"报价";
    NSString *zengyu = @"赠予";
    NSString *dingxiang = @"定向销售";
    NSString *jinpai = @"竞拍";
    NSString *xiang = @"向";
    NSString *yu = @"与";
    NSString *jiaoyi = @"交易";
    
    NSString *addressStr = subParametersModel.address.length>0 ? subParametersModel.address : @"";
    NSString *nftIdStr = subParametersModel.nftId.length>0 ? subParametersModel.nftId : @"";
    NSString *receiveAddressStr = subParametersModel.receiveAddress.length>0 ? subParametersModel.receiveAddress : @"";

//    switch (contenMode.state) {
//        case 0:
//        {
//            str = [NSString stringWithFormat:@"%@{%@}%@{%@}%@{%@}%@",gongXi,addressStr,yu,receiveAddressStr,jiaoyi,nftIdStr,chengGong];
//        }
//            break;
//        case 1:
//        {
//            str = [NSString stringWithFormat:@"%@{%@}%@{%@}%@",yihan,addressStr,jinpai,nftIdStr,shibai];
//        }
//            break;
//        
//        default:
//            break;
//    }
    //0816去掉括号
    switch (contenMode.state) {
        case 1:
        {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",gongXi,addressStr,yu,receiveAddressStr,jiaoyi,nftIdStr,chengGong];
            
            /**
             @"恭喜"
             addressStr"
             @"与"
             receiveAddressStr"
             @"交易"
             nftIdStr"
             @"成功"
             */
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"恭喜%@与%@交易%@成功") ,addressStr,receiveAddressStr,nftIdStr];
            return textS;
        }
            break;
        case 2:
        {
            str = [NSString stringWithFormat:@"%@%@%@%@%@",yihan,addressStr,jinpai,nftIdStr,shibai];
            /**
             @"很遗憾"
             addressStr
             @"竞拍"
             nftIdStr
             @"失败"
             */
            NSString *textS = [NSString stringWithFormat: Y_LocaleTypeFile_NSLocalString(@"很遗憾%@竞拍%@失败") ,addressStr,nftIdStr];
            return textS;
        }
            break;
        
        default:
            break;
    }

    return  str;
    
    
}
@end
