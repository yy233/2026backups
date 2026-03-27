//
//  ZfbPayManager.m
//  Community
//
//  Created by 余莹 on 2021/3/12.
//

#import "ZfbPayManager.h"

@implementation ZfbPayManager
singleton_implementation(shareManager)

- (BOOL)handleOpenURL:(NSURL *)url{
    //________________________________
    // 支付跳转支付宝钱包进行支付，处理支付结果

    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"ZfbPayManager handleOpenURL reslut = %@",resultDic);
        [self getResDic:resultDic];
    }];
    
    //________________________________
    // 授权跳转支付宝钱包进行支付，处理支付结果
    /**
     [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
         NSLog(@"result = %@",resultDic);
         // 解析 auth code
         NSString *result = resultDic[@"result"];
         NSString *authCode = nil;
         if (result.length>0) {
             NSArray *resultArr = [result componentsSeparatedByString:@"&"];
             for (NSString *subResult in resultArr) {
                 if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                     authCode = [subResult substringFromIndex:10];
                     break;
                 }
             }
         }
         NSLog(@"授权结果 authCode = %@", authCode?:@"");
     }];
     */
    
    return YES;
}
- (void)hangleZFPayOrderStr:(NSString *)orderStr{
    NSString *schemeUrl = @"Community";//alisdkdemo zhsj_zfb_2021002119679359  测试后只能用项目名做scheme才能跳回app
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:schemeUrl callback:^(NSDictionary *resultDic) {
        NSLog(@"zfb hangleZFPayOrderStr reslut = %@",resultDic);
        [self getResDic:resultDic];
        
    }];
}

- (void)getResDic:(NSDictionary *)resultDic{
    /**
     ZfbPayManager handleOpenURL reslut = {
         memo = "\U652f\U4ed8\U672a\U5b8c\U6210";
         result = "";
         resultStatus = 6001;
     }
     result = {
     memo = "\U652f\U4ed8\U672a\U5b8c\U6210";
     result = "";
     resultStatus = 6001;
     */
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
        if (![[resultDic allKeys]containsObject:@"resultStatus"]) {
            return;
        }
        NSString *msg = @"";
        if ([[resultDic allKeys]containsObject:@"memo"]) {
            msg = [NSString stringWithFormat:@"%@",resultDic[@"memo"]];
            NSLog(@"hangleZFPayOrderStr___%@___",msg);
        }
      
        switch ([resultDic[@"resultStatus"] integerValue]) {

            case 6001:
            {//@"支付宝用户中途取消"
                if(msg.length<=0){
                    msg = @"支付宝用户中途取消";
                }
                [userInfoDic setValue:msg forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
            }
                break;
            case 6002:
            { // msg = @"网络连接出错";
                if(msg.length<=0){
                    msg = @"网络连接出错";
                }
                [userInfoDic setValue:msg forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
            }
                break;
            case 6004:
            { // msg = @"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                if(msg.length<=0){
                    msg = @"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                }
                [userInfoDic setValue:msg forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
            }
                break;
            case 4000:
            { // msg = @@"订单支付失败";
                if(msg.length<=0){
                    msg = @"订单支付失败";
                }
                [userInfoDic setValue:msg forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
            }
                break;
            case 8000:
            { // msg = @"正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                if(msg.length<=0){
                    msg = @"正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                }
                [userInfoDic setValue:msg forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
            }
                break;

            case 9000:
            {//________成功
                [userInfoDic setValue:@(PayTool_ThisPay_Type_ZFB)      forKey:Pay_Success_PayType_Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PaySuccessedEndInfo_Notice_Name, userInfoDic);
            }
                break;
                
            default:
                //other
                break;
        }
}
 
@end
